import Files

struct ScanRes {
  let tok: Token
  let lit: String
  init(_ tok: Token, _ lit: String) {
    self.tok = tok
    self.lit = lit
  }

}

class Scanner {

  public typealias SIndex = String.UnicodeScalarView.Index
  public typealias SString = String

  public var text: SString
  public var pos: SIndex
  public var posIndex: Int

  public var startIndex: SIndex {
    return self.text.startIndex
  }

  public var endIndex: SIndex {
    return self.text.endIndex
  }

  public var isAtEnd: Bool {
    return self.pos == self.endIndex
  }

  public var isAtBegin: Bool {
    return self.pos == self.startIndex
  }

  let count: Int
  var filePath: String = ""
  var lineNr: Int = 0
  var columnNum: Int = 0
  var lastNewLinePos: SIndex
  var insideString: Bool = false
  var interStart: Bool = false
  var interEnd: Bool = false
  var debug: Bool = false
  var lineComment: String = ""

  var prevTok: Token?
  var tokenNum: Int = 0
  var quote = "\""
  var fileLines: [String] = []
  var fnName: String = ""

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
    self.posIndex = 0
    self.lastNewLinePos = string.startIndex
    self.text = string
    self.count = string.count
  }

  func newToken(_ kind: Kind, _ lit: String, _ len: Int) -> Token {
    let pos = Position(count: len, lineNr: lineNr + 1, pos: self.posIndex - len + 1)
    let idx = tokenNum
    tokenNum += 1
    return Token(kind: kind, lit: lit, pos: pos, tidx: idx)
  }

  func nextChar() -> Character? {
    nextPos()
    return peek()
  }

  func nextPos() {
    pos = text.index(after: pos)
    posIndex += 1
    columnNum += 1
  }

  func peek() -> Character? {
    if isAtEnd {
      return nil
    }
    return text[pos]
  }

  func nextPeek() -> Character? {
    let p = text.index(after: pos)
    if isAtEnd || p == text.endIndex {
      return nil
    }
    return text[p]
  }

  public func index(pos: SIndex, after: Int) -> SIndex {
    posIndex += after
    if let res = text.index(pos, offsetBy: after, limitedBy: endIndex) {
      return res
    }
    return endIndex
  }

  public func _getStr(_ start: SIndex, _ end: SIndex) -> String {
    return String(text[start..<end])
  }

  public func getStr(_ start: SIndex) -> String {
    return _getStr(start, pos)
  }

  func name() -> String? {
    if isAtEnd {
      return nil
    }
    let start = pos
    while let char = nextChar(), char.isLetter() {}
    return getStr(start)
  }

  func funcName() -> String? {
    if isAtEnd {
      return nil
    }
    skipWhitespace()
    let start = pos
    while let char = nextChar(), char.isOperator() {}
    if start == pos {
      return nil
    }
    return getStr(start)
  }

  func skipWhitespace() {
    while let c = peek(), c.isWhitespace() {
      if c.isNewLine() && !expect(want: "\r\n", startPos: index(pos: pos, after: -1)) {
        incLineNum()
      }
      nextPos()
    }
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

  func number() -> String? {
    if isAtEnd {
      return nil
    }
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
    } while true
    return count

  }

  func consumeTillSymbol(endChar: [String]) {
    let slash: Character = "\\"
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

  func string() -> String? {
    let start = pos
    if expect(want: "\"\"\"", startPos: pos) {
      quote = "\"\"\""
    }
    pos = index(pos: pos, after: 3)
    insideString = false
    let slash: Character = "\\"
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
      if let c = peek(), c == "{" && countSymBefore(before: pos, symbol: slash) % 2 == 0 {
        consumeTillSymbol(endChar: [Kind.rcbr.rawValue, quote])
      }

      nextPos()
    }

    return getStr(start)
  }

  func consumeCurrentLine() {
    consumeTillSymbol(endChar: ["\n"])
  }

  func ignoreLine() {
    consumeCurrentLine()
    incLineNum()
    nextPos()
  }

  func constructToken(_ kind: Kind, _ lit: String, _ len: Int = 0, _ count: Int = 0) -> Token {
    pos = index(pos: pos, after: count)
    return newToken(kind, lit, len)
  }

  func comment() -> String? {
    if isAtEnd {
      return nil
    }
    let start = pos
    consumeCurrentLine()
    let str = getStr(start)
    return str
  }

  func scan() -> Token {
    prevTok = scanBasic()
    return prevTok!
  }

  func scanBasic() -> Token {
    if isAtEnd {
      return constructToken(.eof, "")
    }

    if let c = peek() {
      if c.isLetter() {
        let n = name()!
        if Kind.isKeyword(n) {
          return constructToken(Kind.keyToKind(n)!, "", n.count)
        }
        return constructToken(.name, n, n.count)
      }
      if c.isDigit() {
        let num = number()!
        return constructToken(.number, num, num.count)
      }
      if prevTok != nil && prevTok!.isFunction() && c.isOperator() {
        let n = funcName()!
        return constructToken(.name, n, n.count)
      }
    switch c {
      case "+", "-", "*", "/", "%", "^", "=":
        if let d = nextPeek(), d == "=" || c == "*" && d == "*" {
          return constructToken(Kind(rawValue: String([c,d]))!, "", 2, 2)
        }
        return constructToken(Kind(rawValue: String(c))!, "", 1, 1)
      case "?", "(", ")", "[", "]", "{", "}", ",", ";", "@", ":":
        return constructToken(Kind(rawValue: String(c))!, "", 1, 1)
      case "#":
        let cmt = comment()!
        return constructToken(.comment, cmt, cmt.count)
      case "\r":
        if let d = nextPeek(), d == "\n" {
          lastNewLinePos = pos
          return constructToken(.nl, "", 2, 2)
        }
        return constructToken(.nl, "", 1, 1)
      case "\n":
        lastNewLinePos = pos
        return constructToken(.nl, "", 1, 1)
      case "\t", " ":
        return constructToken(Kind(rawValue: String(c))!, "", 1, 1)
      case ".":
        if expect(want: "...", startPos: pos) {
          return constructToken(.range, "", 3, 3)
        }
        if expect(want: "..<", startPos: pos) {
          return constructToken(.halfRange, "", 3, 3)
        }
        return constructToken(.dot, "", 1, 1)
      case ">", "<":
        if let d = nextPeek(), d == "=" || c == d {
          return constructToken(Kind(rawValue: String([c, d]))!, "", 2, 2)
        }
        return constructToken(Kind(rawValue: String(c))!, "", 1, 1)
      case "&", "|":
        if let d = nextPeek(), d == "=" {
          return constructToken(Kind(rawValue: String([c, d]))!, "", 2, 2)
        }
        return constructToken(Kind(rawValue: String(c))!, "", 1, 1)
      case "\"":
        let str = string()!
        return constructToken(.string, str, str.count)
      default:
        return constructToken(.unknown, "")
      }
    }
    return constructToken(.unknown, "")
  }


  func error(_ str: String) {
    fatalError(str)
  }

  func expect(want: String, startPos: SIndex) -> Bool {
    let endPos = index(pos: startPos, after: want.count)
    return want == _getStr(startPos, endPos)
  }
}
