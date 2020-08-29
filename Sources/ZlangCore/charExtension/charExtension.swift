// import token

extension Character {
  static let binDigit: Set<Character> = ["0", "1"]
  static let octDigit: Set<Character> = binDigit.union(["2", "3", "4", "5", "6", "7"])
  static let decDigit: Set<Character> = octDigit.union(["8", "9"])
  static let hexDigit: Set<Character> = decDigit.union([
    "A", "B", "C", "D", "E", "F", "a", "b", "c", "d", "e", "f",
  ])

  static let prefixHex = "0x"
  static let prefixOct = "0o"
  static let prefixBin = "0b"
  static let prefixDec = ""
  static let underscore: Character = "_"
  static let hexExp = "p"
  static let octExp = "p"
  static let binExp = "p"
  static let decExp = "e"

  func isWhitespace() -> Bool {
    return Kind.Whitespace.contains(Kind.getKind(self))
  }

  func isSplits() -> Bool {
    return Kind.Splits.contains(Kind.getKind(self))
  }

  func isOperator() -> Bool {
    return Kind.Operators.contains(Kind.getKind(self))
  }

  func isEof() -> Bool {
    return .eof == Kind.getKind(self)
  }

  func isComment() -> Bool {
    return .comment == Kind.getKind(self)
  }

  func isNewLine() -> Bool {
    return [Kind.nl, Kind.nl2].contains(Kind.getKind(self))
  }

  func isLetter() -> Bool {
    return !isWhitespace() && !isSplits() && !isOperator() && !isComment() && !isDigit()
  }

  func isBinDigit() -> Bool {
    return Character.binDigit.contains(self)
  }

  func isOctDigit() -> Bool {
    return Character.octDigit.contains(self)
  }

  func isDecDigit() -> Bool {
    return Character.decDigit.contains(self)
  }

  func isHexDigit() -> Bool {
    return Character.hexDigit.contains(self)
  }

  func isDigit(_ prefixStr: String = "") -> Bool {
    switch prefixStr {
    case Character.prefixBin:
      return isBinDigit()
    case Character.prefixHex:
      return isHexDigit()
    case Character.prefixOct:
      return isOctDigit()
    default:
      return isDecDigit()
    }
  }

  func isUnderScore() -> Bool {
    return self == Character.underscore
  }

}
