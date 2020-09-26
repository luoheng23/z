public enum Kind: String {
  case unknown = "unknown"
  case eof = "eof"
  case comment = "#"
  case name = "name"  // user
  case number = "number"  // 123
  case string = "string"  // 'foo'
  case chartoken = "char"  // `A`
  case plus = "+"
  case minus = "-"
  case mul = "*"
  case div = "/"
  case mod = "%"
  case pow = "**"
  case xor = "^"
  case pipe = "|"
  case bit_not = "~"
  case question = "?"
  case comma = ","
  case semicolon = ";"
  case colon = ":"
  case amp = "&"
  case left_shift = "<<"
  case right_shift = ">>"
  case at = "@"
  case assign = "="
  case plus_assign = "+="  // +=
  case minus_assign = "-="  // -=
  case div_assign = "/="
  case mult_assign = "*="
  case pow_assign = "**="
  case xor_assign = "^="
  case mod_assign = "%="
  case or_assign = "|="
  case and_assign = "&="
  case right_shift_assign = ">>="
  case left_shift_assign = "<<="
  case lcbr = "{"
  case rcbr = "}"
  case lpar = "("
  case rpar = ")"
  case lsbr = "["
  case rsbr = "]"

  case quote = "\""

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
  case range = "..."
  case halfRange = "..<"

  case key_and = "and"
  case key_break = "break"
  case key_case = "case"
  case key_let = "let"
  case key_continue = "continue"
  case key_default = "default"
  case key_defer = "defer"
  case key_else = "else"
  case key_enum = "enum"
  case key_impl = "impl"
  case key_false = "false"
  case key_fallthrough = "fallthrough"
  case key_for = "for"
  case key_func = "fn"
  case key_go = "go"
  case key_if = "if"
  case key_import = "import"
  case key_in = "in"
  case key_not_in = "not in"
  case key_interface = "interface"
  case key_is = "is"
  case key_is_not = "is not"
  case key_mut = "mut"
  case key_nil = "nil"
  case key_not = "not"
  case key_or = "or"
  case key_pub = "pub"
  case key_static = "static"
  case key_struct = "struct"
  case key_switch = "switch"
  case key_return = "return"
  case key_true = "true"
  case key_type = "type"
  case key_var = "var"
  case key_with = "with"

  init?() {
    self.init(rawValue: "unknown")
  }

  // buildKeys genereates a map with keywords' string values:
  // Keywords['return'] == .key_return
  static func buildKeys() -> [String: Kind] {
    var res = [String: Kind]()
    for c in Kind.keywords {
      res[c.rawValue] = c
    }
    return res
  }

  static let keywords: [Kind] = [
    .key_and,
    .key_break,
    .key_case,
    .key_let,
    .key_continue,
    .key_default,
    .key_defer,
    .key_else,
    .key_enum,
    .key_impl,
    .key_false,
    .key_fallthrough,
    .key_for,
    .key_func,
    .key_go,
    .key_if,
    .key_import,
    .key_in,
    .key_interface,
    .key_is,
    .key_mut,
    .key_nil,
    .key_not,
    .key_pub,
    .key_or,
    .key_static,
    .key_struct,
    .key_switch,
    .key_return,
    .key_true,
    .key_type,
    .key_var,
    .key_with,
  ]

  static let KEYWORDS = buildKeys()

  static let Decls: [Kind] = [
    .key_enum,
    .key_impl,
    .key_interface,
    .key_func,
    .key_struct,
    .key_type,
    .key_let,
    .key_var,
  ]

  static let Assigns: [Kind] = [
    .assign,
    .plus_assign,
    .minus_assign,
    .mult_assign,
    .div_assign,
    .xor_assign,
    .mod_assign,
    .or_assign,
    .and_assign,
    .right_shift_assign,
    .pow_assign,
    .left_shift_assign,
  ]

  static let Splits: [Kind] = [
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
    .quote,
  ]

  static let Whitespace: [Kind] = [
    .space,
    .tab,
    .nl,
    .nl2,
  ]

  static let Operators: [Kind] = [
    .plus,
    .minus,
    .mul,
    .div,
    .pow,
    .mod,
    .xor,
    .pipe,
    .bit_not,
    .amp,
    .at,
    .dot,
    .assign,
    .gt,
    .lt,
  ]

  static func keyToKind(_ key: String) -> Kind {
    return KEYWORDS[key] ?? .unknown
  }

  static func isKeyword(_ key: String) -> Bool {
    return keyToKind(key) != .unknown
  }

  func str() -> String {
    return "Kind \(text())"
  }

  func text() -> String {
    return self.rawValue
  }

  static func isDecl(_ str: String) -> Bool {
    return Kind.Decls.contains(getKind(str))
  }

  static func getKind(_ rawValue: String) -> Kind {
    return Kind(rawValue: rawValue) ?? .unknown
  }

  static func getKind(_ chars: Character...) -> Kind {
    return getKind(String(chars))
  }

  static func isAssign(_ str: String) -> Bool {
    return Assigns.contains(getKind(str))
  }

  func isDecl() -> Bool {
    return Kind.Decls.contains(self)
  }

  func isAssign() -> Bool {
    return Kind.Assigns.contains(self)
  }

  func isFunction() -> Bool {
    return isKind(.key_func)
  }

  func isKind(_ kind: Kind) -> Bool {
    return self == kind
  }

  func isNotKind(_ kind: Kind) -> Bool {
    return !isKind(kind)
  }

  func gen() -> String {
    return text()
  }
}
