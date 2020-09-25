import Files

typealias SIndex = String.UnicodeScalarView.Index

typealias SString = String

class Scanner {

  var text: SString
  var pos: SIndex

  var isAtEnd: Bool {
    return self.pos == self.text.endIndex
  }

  var isAtBegin: Bool {
    return self.pos == self.text.startIndex
  }

  var file: ZFile = ZFile()

  var offset: Int = 0
  var column: Int = 0
  var lineNum: Int = 0

  var insertSemi: Bool = false
  var errorCount: Int = 0

  var prevTok: Token?  // previous token
  var tok: Token = Token()

  init(file: ZFile, src: String) {
    self.file = file
    self.text = src
    self.pos = src.startIndex
  }

  init(_ string: String) {
    self.pos = string.startIndex
    self.text = string
  }

  func nextChar() -> Character? {
    nextPos()
    return peek()
  }

  func nextPos() {
    if peek() != nil {
      pos = text.index(after: pos)
      offset += 1
      column += 1
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
    var limit = text.endIndex
    if after < 0 {
      limit = text.startIndex
    }
    if let res = text.index(pos, offsetBy: after, limitedBy: limit) {
      return res
    }
    return limit
  }

  func _getTokenString(_ start: SIndex, _ end: SIndex) -> String {
    return String(text[start..<end])
  }

  func getTokenString(_ start: SIndex) -> String {
    return _getTokenString(start, pos)
  }

  func scanName() -> String {
    let start = pos
    while let char = nextChar(), char.isLetter() {}
    return getTokenString(start)
  }

  func scanFuncName() -> String {
    let start = pos
    while let char = nextChar(), char.isOperator() {}
    return getTokenString(start)
  }

  func skipWhitespace() {
    while let c = peek(), c.isWhitespace() {
      if c.isNewLine() && insertSemi {
        break
      }
      if c.isNewLine() && !expect(want: "\r\n", startPos: index(pos: pos, after: -1)) {
        incLineNum()
      }
      nextPos()
    }
  }

  func incLineNum() {
    file.addLine(index(pos: pos, after: 1))
    lineNum += 1
    column = 0
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
        if expect(want: char, startPos: pos) && countSymBefore(before: pos, symbol: "\\") % 2 == 0 {
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
      if expect(want: quote, startPos: pos) && countSymBefore(before: pos, symbol: "\\") % 2 == 0 {
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
      nextPos()
    }

    return getTokenString(start)
  }

  func consumeCurrentLine() {
    consumeTillSymbol(endChar: ["\n"])
  }

  func newToken(_ kind: Kind, _ lit: String, _ len: Int) -> Token {
    let pos = Position(file.name, offset, lineNum + 1, self.column - len + 1)
    return Token(kind: kind, lit: lit, pos: pos)
  }

  func constructToken(_ kind: Kind, _ lit: String, _ len: Int = 0, _ count: Int = 0) -> Token {
    pos = index(pos: pos, after: count)
    return newToken(kind, lit, len)
  }

  func scanComment() -> String {
    let start = pos
    consumeCurrentLine()
    return getTokenString(start)
  }

  func getLineInfo(_ pos: Position) -> String {
    return String(text[file.lines[pos.line]..<file.lines[pos.line + 1]])
  }

  func scan() -> Token {
    let tok = scanBasic()
    prevTok = tok
    return tok
  }

  func scanBasic() -> Token {
    if isAtEnd {
      return constructToken(.eof, Kind.eof.rawValue)
    }

    skipWhitespace()

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
      case "*":
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
      case ".":
        if expect(want: "...", startPos: pos) {
          return constructToken(.range, Kind.range.rawValue, 3, 3)
        }
        if expect(want: "..<", startPos: pos) {
          return constructToken(.halfRange, Kind.halfRange.rawValue, 3, 3)
        }
        return constructToken(.dot, Kind.dot.rawValue, 1, 1)
      case ">", "<", "+", "-":
        if let d = nextPeek(), d == "=" || c == d {
          let kind = Kind.getKind(c, d)
          return constructToken(kind, kind.rawValue, 2, 2)
        }
        let kind = Kind.getKind(c)
        return constructToken(kind, kind.rawValue, 1, 1)
      case "&", "|", "/", "%", "^", "=":
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
        return constructToken(.eof, Kind.eof.rawValue)
      }
    }
    return constructToken(.eof, Kind.eof.rawValue)
  }

  func error(_ str: String) {
    print(str)
  }

  func expect(want: String, startPos: SIndex) -> Bool {

    let endPos = index(pos: startPos, after: want.count)
    return want == _getTokenString(startPos, endPos)
  }
}
