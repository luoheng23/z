class Ast: Position {
  // readonly node name
  var node: String { String(describing: type(of: self)) }

  func str() -> String {
    return "\(node)()"
  }

  func text() -> String {
    return ""
  }

  func gen() -> String {
    return text()
  }
}

class Decl: Stmt {}

class Stmt: Ast {}

class Expr: Ast {}
