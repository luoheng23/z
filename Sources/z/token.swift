// Copyright (c) 2019 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by an MIT license
// that can be found in the LICENSE file.

public enum Token: String {
  case none = ""
  case eof = "eof"
  case comment = "#"
  case name = "name"  // user
  case number = "number"  // 123
  case str = "str"  // 'foo'
  case chartoken = "char"  // `A`
  case plus = "+"
  case minus = "-"
  case mul = "*"
  case div = "/"
  case mod = "%"
  case xor = "^"  // ^
  case pipe = "|"  // |
  case and = "&&"  // &&
  case logical_or = "||"
  case not = "!"
  case bit_not = "~"
  case question = "?"
  case comma = ","
  case semicolon = ";"
  case colon = ":"
  case amp = "&"
  case dollar = "$"
  case left_shift = "<<"
  case righ_shift = ">>"
  case at = "@"
  case assign = "="
  case plus_assign = "+="  // +=
  case minus_assign = "-="  // -=
  case div_assign = "/="
  case mult_assign = "*="
  case xor_assign = "^="
  case mod_assign = "%="
  case or_assign = "|="
  case and_assign = "&="
  case righ_shift_assign = ">>="
  case left_shift_assign = "<<="
  case lcbr = "{"
  case rcbr = "}"
  case lpar = "("
  case rpar = ")"
  case lsbr = "["
  case rsbr = "]"

  case sinQuote = "'"
  case douQuote = "\""

  case eq = "=="
  case ne = "!="
  case gt = ">"
  case lt = "<"
  case ge = ">="
  case le = "<="

  case tab = "\t"
  case nl = "\n"
  case space = " "
  case nl2 = "\r"

  case dot = "."
  case dotdot = "..."

  case key_is = "is"
  case key_atomic = "atomic"
  case key_break = "break"
  case key_case = "case"
  case key_const = "const"
  case key_var = "var"
  case key_continue = "continue"
  case key_default = "default"
  case key_defer = "defer"
  case key_else = "else"
  case key_enum = "enum"
  case key_false = "false"
  case key_for = "for"
  case key_func = "fn"
  case key_go = "go"
  case key_if = "if"
  case key_import = "import"
  case key_in = "in"
  case key_interface = "interface"
  case key_switch = "switch"
  case key_mut = "mut"
  case key_none = "nil"
  case key_return = "return"
  case key_struct = "struct"
  case key_true = "true"
  case key_type = "type"
  case key_pub = "pub"
  case key_static = "static"

  // buildKeys genereates a map with keywords' string values:
  // Keywords['return'] == .key_return
  static func buildKeys() -> [String: Token] {
    var res = [String: Token]()
    for c in Token.keywords {
      res[c.rawValue] = c
    }
    return res
  }

  static let keywords: [Token] = [
    .key_is,
    .key_atomic,
    .key_break,
    .key_case,
    .key_const,
    .key_var,
    .key_continue,
    .key_default,
    .key_defer,
    .key_else,
    .key_enum,
    .key_false,
    .key_for,
    .key_func,
    .key_go,
    .key_if,
    .key_import,
    .key_in,
    .key_interface,
    .key_switch,
    .key_mut,
    .key_none,
    .key_return,
    .key_struct,
    .key_true,
    .key_type,
    .key_pub,
    .key_static,
  ]

  static let KEYWORDS = buildKeys()

  static let Decls: [Token] = [
    .key_enum,
    .key_interface,
    .key_func,
    .key_struct,
    .key_type,
    .key_const,
    .key_var,
    .key_mut,
    .key_pub,
  ]

  static let Assigns: [Token] = [
    .assign, .plus_assign, .minus_assign,
    .mult_assign, .div_assign, .xor_assign,
    .mod_assign,
    .or_assign, .and_assign, .righ_shift_assign,
    .left_shift_assign,
  ]

  static let Splits: [Token] = [
    .lcbr,
    .rcbr,
    .lpar,
    .rpar,
    .lsbr,
    .rsbr,
    .question,
    .comma,
    .semicolon,
    .colon,
  ]

  static let Whitespace: [Token] = [
    .space,
    .tab,
    .nl,
    .nl2,
  ]

  static let Operators: [Token] = [
    .plus,
    .minus,
    .mul,
    .div,
    .mod,
    .xor,
    .pipe,
    .not,
    .bit_not,
    .amp,
    .dollar,
    .at,
    .assign,
    .gt,
    .lt,
  ]

  static func keyToToken(_ key: String) -> Token? {
    return KEYWORDS[key]
  }

  static func isKeyword(_ key: String) -> Bool {
    return keyToToken(key) != nil
  }

  func isKeyword() -> Bool {
    return Token.isKeyword(self.rawValue)
  }

  func string() -> String {
    return self.rawValue
  }

  static func isDecl(_ str: String) -> Bool {
    return Token.Decls.contains(Token(rawValue: str) ?? .none)
  }

  func isDecl() -> Bool {
    return Token.Decls.contains(self)
  }

  static func isAssign(_ str: String) -> Bool {
    return Token.Assigns.contains(Token(rawValue: str) ?? .none)
  }

  func isAssign() -> Bool {
    return Token.Assigns.contains(self)
  }
}

extension Character {
  static let binDigit: Set<Character> = ["0", "1"]
  static let octDigit: Set<Character> = binDigit.union(["2", "3", "4", "5", "6", "7"])
  static let decDigit: Set<Character> = octDigit.union(["8", "9"])
  static let hexDigit: Set<Character> = decDigit.union(["A", "B", "C", "D", "E", "F", "a", "b", "c", "d", "e", "f"])

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
    return Token.Whitespace.contains(Token(rawValue: String(self)) ?? .none)
  }

  func isSplits() -> Bool {
    return Token.Splits.contains(Token(rawValue: String(self)) ?? .none)
  }

  func isOperator() -> Bool {
    return Token.Operators.contains(Token(rawValue: String(self)) ?? .none)
  }

  func isNewLine() -> Bool {
    return [Token.nl, Token.nl2].contains(Token(rawValue: String(self)) ?? .none)
  }

  func isLetter() -> Bool {
    return !isWhitespace() && !isSplits() && !isOperator()
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
    switch (prefixStr) {
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
