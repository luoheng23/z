import Files

class Scanner {

  var text: SString
  var pos: SIndex

  var startIndex: SIndex {
    return self.text.startIndex
  }

  var endIndex: SIndex {
    return self.text.endIndex
  }

  var isAtEnd: Bool {
    return self.pos == self.endIndex
  }

  var isAtBegin: Bool {
    return self.pos == self.startIndex
  }

  let count: Int // total length of text
  var filePath: String = "" // filepath
  var lineNr: Int = 0  // number of newline
  var columnNum: Int = 0 // current column
  var lastNewLinePos: SIndex  // last pos of newline

  let slash: Character = "\\"

  var prevTok: Token? // previous token
  var tokenNum: Int = 0  // current tokens


  convenience init(filePath: String) {
    if let file = try? (try? File(path: filePath))?.read() {
      self.init(String(decoding: file, as: UTF8.self))
      self.filePath = filePath
    } else {
      self.init("")
      error("\(filePath) doesn't exist")
    }
  }

  init(_ string: String) {
    self.pos = string.startIndex
    self.lastNewLinePos = string.startIndex
    self.text = string
    self.count = string.count
  }

  func newToken(_ kind: Kind, _ lit: String, _ len: Int) -> Token {
    let pos = Position(count: len, lineNr: lineNr + 1, pos: self.columnNum - len + 1, 
                  lineBegin: lastNewLinePos)
    tokenNum += 1
    return Token(kind: kind, lit: lit, pos: pos)
  }

  func nextChar() -> Character? {
    nextPos()
    return peek()
  }

  func nextPos() {
    if peek() != nil {
      pos = text.index(after: pos)
      columnNum += 1
    }
  }

  func peek() -> Character? {
    if isAtEnd {
      return nil
    }
    return text[pos]
  }

  func nextPeek() -> Character? {
    let p = index(pos: pos, after: 1)
    if isAtEnd || p == text.endIndex {
      return nil
    }
    return text[p]
  }

  func next2Peek() -> Character? {
    let p = index(pos: pos, after: 2)
    if isAtEnd || p == text.endIndex {
      return nil
    }
    return text[p]
  }
  func index(pos: SIndex, after: Int) -> SIndex {
    if let res = text.index(pos, offsetBy: after, limitedBy: endIndex) {
      return res
    }
    return endIndex
  }

  func _getStr(_ start: SIndex, _ end: SIndex) -> String {
    return String(text[start..<end])
  }

  func getStr(_ start: SIndex) -> String {
    return _getStr(start, pos)
  }

  func scanName() -> String {
    skipWhitespace()
    let start = pos
    while let char = nextChar(), char.isLetter() {}
    return getStr(start)
  }

  func scanFuncName() -> String {
    skipWhitespace()
    let start = pos
    while let char = nextChar(), char.isOperator() {}
    return getStr(start)
  }

  @discardableResult
  func skipWhitespace(_ skipNewLine: Bool = true) -> String {
    let start = pos
    while let c = peek(), c.isWhitespace() {
      if c.isNewLine() && !expect(want: "\r\n", startPos: index(pos: pos, after: -1)) {
        incLineNum()
      }
      nextPos()
    }
    return getStr(start)
  }

  func incLineNum() {
    lastNewLinePos = pos
    lineNr += 1
    columnNum = 0
  }

  func hexNum() -> String {
    return _num(prefixStr: Character.prefixHex, exponent: Character.hexExp)
  }

  func octNum() -> String {
    return _num(prefixStr: Character.prefixOct, exponent: Character.octExp)
  }

  func decNum() -> String {
    return _num(prefixStr: Character.prefixDec, exponent: Character.decExp)
  }

  func binNum() -> String {
    return _num(prefixStr: Character.prefixBin, exponent: Character.binExp)
  }

  func _numIntegerPart(prefixStr: String) {
    var isUnderScore = false
    while true {
      if let c = peek(), c.isDigit(prefixStr) || isUnderScore && c.isUnderScore() {
        isUnderScore = c.isDigit(prefixStr)
        nextPos()
      } else {
        break
      }
    }

    if !isUnderScore {
      error("failed to parse integer \(peek() ?? Character(""))")
    }
  }

  func _num(prefixStr: String, exponent: String) -> String {
    let start = pos
    pos = index(pos: pos, after: prefixStr.count)
    _numIntegerPart(prefixStr: prefixStr)
    // scan fractional part
    if let c = peek(), let c2 = nextPeek(), c == "." && c2.isDigit(prefixStr) {
      nextPos()
      _numIntegerPart(prefixStr: prefixStr)
    }
    // scan exponential part
    if expect(want: exponent.lowercased(), startPos: pos)
      || expect(want: exponent.uppercased(), startPos: pos)
    {
      nextPos()
      if let c = peek(), ["+", "-"].contains(c) {
        nextPos()
      }
      _numIntegerPart(prefixStr: prefixStr)
    }
    return getStr(start)
  }

  func scanNumber() -> String {
    if expect(want: Character.prefixHex, startPos: pos) {
      return hexNum()
    }
    if expect(want: Character.prefixOct, startPos: pos) {
      return octNum()
    }
    if expect(want: Character.prefixBin, startPos: pos) {
      return binNum()
    }
    return decNum()
  }

  func countSymBefore(before pos: SIndex, symbol: Character) -> Int {
    var position = pos
    var count = 0
    repeat {
      position = index(pos: position, after: -1)
      if text[position] == symbol {
        count += 1
      } else {
        break
      }
      if isAtBegin {
        break
      }
    } while true
    return count

  }

  func consumeTillSymbol(endChar: [String]) {
    consumeLoop: while true {
      nextPos()
      if isAtEnd {
        break consumeLoop
      }
      for char in endChar {
        if expect(want: char, startPos: pos) && countSymBefore(before: pos, symbol: slash) % 2 == 0
        {
          break consumeLoop
        }
      }
    }
  }

  func scanString() -> String {
    let start = pos
    let quote = expect(want: "\"\"\"", startPos: pos) ? "\"\"\"" : "\""
    pos = index(pos: pos, after: 3)
    while true {
      if isAtEnd {
        break
      }
      if expect(want: quote, startPos: pos) && countSymBefore(before: pos, symbol: slash) % 2 == 0 {
        // end of str
        pos = index(pos: pos, after: quote.count)
        break
      }

      if let c = peek(), c == "\n" {
        if quote.count == 3 {
          incLineNum()
        } else {
          error("Parse string meets unexpected newline")
        }
      }
      // if let c = peek(), c == "{" && countSymBefore(before: pos, symbol: slash) % 2 == 0 {
      //   consumeTillSymbol(endChar: [Kind.rcbr.rawValue, quote])
      // }
      nextPos()
    }

    return getStr(start)
  }

  func consumeCurrentLine() {
    consumeTillSymbol(endChar: ["\n"])
  }

  func constructToken(_ kind: Kind, _ lit: String, _ len: Int = 0, _ count: Int = 0) -> Token {
    pos = index(pos: pos, after: count)
    return newToken(kind, lit, len)
  }

  func scanComment() -> String {
    let start = pos
    consumeCurrentLine()
    return getStr(start)
  }

  func getLineInfo(_ pos: Position) -> String {
    return String(text[pos.lineBegin..<lastNewLinePos])
  }

  func scan(_ skipWhitespace: Bool = true) -> Token {
    var tok: Token
    repeat {
      tok = scanBasic()
      if tok.kind == .eof {
        break
      }
      if !skipWhitespace || tok.kind != .space && tok.kind != .nl{
        break
      }
    } while true
    prevTok = tok
    return prevTok!
  }

  func scanBasic() -> Token {
    if isAtEnd {
      return constructToken(.eof, Kind.eof.rawValue)
    }

    if let c = peek() {
      if c.isLetter() {
        let n = scanName()
        if Kind.isKeyword(n) {
          let kind = Kind.keyToKind(n)
          return constructToken(kind, kind.rawValue, n.count)
        }
        return constructToken(.name, n, n.count)
      }
      if c.isDigit() {
        let num = scanNumber()
        return constructToken(.number, num, num.count)
      }
      if prevTok != nil && prevTok!.isFunction() && c.isOperator() {
        let n = scanFuncName()
        return constructToken(.name, n, n.count)
      }
    switch c {
      case "+", "-", "*", "/", "%", "^", "=":
        if let d = nextPeek() {
          if c == "*" && d == "*" {
            if let e = next2Peek(), e == "=" {
              let kind = Kind.getKind(c, d, e)
              return constructToken(kind, kind.rawValue, 3, 3)
            }
            let kind = Kind.getKind(c, d)
            return constructToken(kind, kind.rawValue, 2, 2)
          }
          if d == "=" {
            let kind = Kind.getKind(c, d)
            return constructToken(kind, kind.rawValue, 2, 2)
          }
        }
        let kind = Kind.getKind(c)
        return constructToken(kind, kind.rawValue, 1, 1)
      case "?", "(", ")", "[", "]", "{", "}", ",", ";", "@", ":":
        let kind = Kind.getKind(c)
        return constructToken(kind, kind.rawValue, 1, 1)
      case "#":
        let cmt = scanComment()
        return constructToken(.comment, cmt, cmt.count)
      case "\r", "\n":
        incLineNum()
        if let d = nextPeek(), c == "\r" && d == "\n" {
          return constructToken(.nl, Kind.nl.rawValue, 2, 2)
        }
        return constructToken(.nl, Kind.nl.rawValue, 1, 1)
      case "\t", " ":
        let space = skipWhitespace(false)
        return constructToken(.space, space, space.count)
      case ".":
        if expect(want: "...", startPos: pos) {
          return constructToken(.range, Kind.range.rawValue, 3, 3)
        }
        if expect(want: "..<", startPos: pos) {
          return constructToken(.halfRange, Kind.halfRange.rawValue, 3, 3)
        }
        return constructToken(.dot, Kind.dot.rawValue, 1, 1)
      case ">", "<":
        if let d = nextPeek(), d == "=" || c == d {
          let kind = Kind.getKind(c, d)
          return constructToken(kind, kind.rawValue, 2, 2)
        }
        let kind = Kind.getKind(c)
        return constructToken(kind, kind.rawValue, 1, 1)
      case "&", "|":
        if let d = nextPeek(), d == "=" {
          let kind = Kind.getKind(c, d)
          return constructToken(kind, kind.rawValue, 2, 2)
        }
        let kind = Kind.getKind(c)
        return constructToken(kind, kind.rawValue, 1, 1)
      case "\"":
        let str = scanString()
        return constructToken(.string, str, str.count)
      default:
        return constructToken(.unknown, Kind.unknown.rawValue)
      }
    }
    return constructToken(.unknown, Kind.unknown.rawValue)
  }


  func error(_ str: String) {
    fatalError(str)
  }

  func expect(want: String, startPos: SIndex) -> Bool {
    let endPos = index(pos: startPos, after: want.count)
    return want == _getStr(startPos, endPos)
  }
}
