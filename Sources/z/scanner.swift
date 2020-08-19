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

  var filePath: String = ""
  var newlineNum: Int = 0
  var columnNum: Int = 0
  let count: Int
  var lastNewLinePos: SIndex
  var insideString: Bool = false
  var interStart: Bool = false
  var interEnd: Bool = false
  var debug: Bool = false
  var lineComment: String = ""

  var quote = "\""
  var fileLines: [String] = []
  var prevTok: Token?
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
    self.lastNewLinePos = string.startIndex
    self.text = string
    self.count = string.count
  }

  func nextChar() -> Character? {
    nextPos()
    return peek()
  }

  func nextPos() {
    pos = text.index(after: pos)
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
    newlineNum += 1
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
        consumeTillSymbol(endChar: [Token.rcbr.rawValue, quote])
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
  }

  func scan() -> ScanRes {
    if isAtEnd {
      return ScanRes(.eof, "")
    }
    if let c = peek() {
      if c.isLetter() {
        let n = name()!
        if Token.isKeyword(n) {
          return ScanRes(Token.keyToToken(n)!, "")
        }
        return ScanRes(.name, n)
      }
      if c.isDigit() {
        let num = number()!
        return ScanRes(.number, num)
      }
      switch c {
      case "+", "-", "*", "/", "%", "^", "!", "=":
        if let d = nextPeek(), d == "=" {
          nextPos()
          return ScanRes(Token(rawValue: String([c, d]))!, "")
        }
        return ScanRes(Token(rawValue: String(c))!, "")
      case "?", "(", ")", "[", "]", "{", "}", ",", ";", "@", "#":
        return ScanRes(Token(rawValue: String(c))!, "")
      case "\r":
        if let d = nextPeek(), d == "\n" {
          nextPos()
          lastNewLinePos = pos
          return ScanRes(.nl, "")
        }
      case "\n":
        lastNewLinePos = pos
        return ScanRes(.nl, "")
      case ".":
        if expect(want: "...", startPos: pos) {
          pos = index(pos: pos, after: 3)
          return ScanRes(.dotdot, "")
        }
        return ScanRes(.dot, "")
      case ">", "<", "&", "|":
        if let d = nextPeek(), d == "=" || c == d {
          return ScanRes(Token(rawValue: String([c, d]))!, "")
        }
      case "\"":
        let str = string()!
        return ScanRes(.str, str)
      default:
        return ScanRes(.eof, "")
      }
    }
    return ScanRes(.eof, "")
  }

  func error(_ str: String) {
    fatalError(str)
  }

  func expect(want: String, startPos: SIndex) -> Bool {
    let endPos = index(pos: startPos, after: want.count)
    return want == _getStr(startPos, endPos)
  }
}
