extension Parser {

  func literal() -> Literal {
    switch tok.kind {
    case .key_true, .key_false:
      return boolLiteral()
    case .key_nil:
      return noneLiteral()
    case .number:
      return numberLiteral()
    case .string:
      return stringLiteral()
    default:
      error("unreachable code here \(tok.str())")
      return Literal(val: tok, tok.pos)
    }
  }

  func boolLiteral() -> BoolLiteral {
    let node = BoolLiteral(val: tok, tok.pos)
    check(.unknown, true)
    return node
  }

  func noneLiteral() -> NoneLiteral {
    let node = NoneLiteral(val: tok, tok.pos)
    check(.unknown, true)
    return node
  }

  func stringLiteral() -> StringLiteral {
    let node = StringLiteral(val: tok, tok.pos)
    check(.unknown, true)
    return node
  }

  func numberLiteral() -> Literal {
    var node: Literal
    if tok.lit.hasPrefix("0x") && tok.lit.contains(where: [".", "p", "P"].contains)
      || !tok.lit.hasPrefix("0x") && tok.lit.contains(where: [".", "e", "E", "p", "P"].contains)
    {
      node = FloatLiteral(val: tok, tok.pos)
    } else {
      node = IntegerLiteral(val: tok, tok.pos)
    }
    check(.unknown, true)
    return node
  }

}
