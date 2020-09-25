class Literal: Expr {
  let val: Token

  init(val: Token, _ pos: Position) {
    self.val = val
    super.init(pos)
  }

  override func str() -> String {
    return "\(node)(\(text()))"
  }
  override func text() -> String {
    return val.lit
  }
}

class NoneLiteral: Literal {}

class BoolLiteral: Literal {}

class FloatLiteral: Literal {}

class IntegerLiteral: Literal {}

class StringLiteral: Literal {}
