extension Parser {
  func expr(_ precedence: Int = 0) -> Expr {
    var node: Expr
    switch tok.kind {
    case .key_true, .key_false, .key_nil, .number, .string:
      node = literal()
    case .dot:
      node = enumValueExpr()
    case .lpar:
      node = tupleExpr()
    case .name:
      node = nameExpr()
    case .minus, .plus, .amp, .mul, .key_not, .bit_not:
      node = prefixExpr()
    default:
      error("Invalid expression token '\(tok.text())'")
      return Expr()
    }
    // Infix
    while precedence < tok.precedence() {
      switch tok.kind {
      case .dot:
        node = dotExpr(node)
      case .lsbr:
        node = indexExpr(node)
      case .lpar:
        node = callExpr(node)
      case .question:
        node = ifElseExpr(node)
      default:
        if tok.isInfix() {
          node = infixExpr(node)
        } else {
          return node
        }
      }
    }
    return node
  }

  func enumValueExpr() -> EnumValueExpr {
    check(.dot)
    let node = EnumValueExpr(val: nameExpr(), tok.pos)
    return node
  }

  func tupleExpr() -> TupleExpr {
    let pos = tok.pos
    check(.lpar)
    let n = basicTupleExpr({ () -> Expr in expr() })
    check(.rpar)
    let node = TupleExpr(n, pos)
    return node
  }

  func prefixExpr() -> PrefixExpr {
    let pos = tok.pos
    let op = tok.kind
    check(.unknown, true)
    let right = expr(Precedence.pref.rawValue)
    return PrefixExpr(op: op, right: right, pos)
  }

  func infixExpr(_ left: Expr) -> Expr {
    let op = tok.kind
    let precedence = tok.precedence()
    let pos = tok.pos
    next()
    let right = expr(precedence)
    return InfixExpr(left: left, right: right, op: op, pos: pos)
  }

  func dotExpr(_ left: Expr) -> DotExpr {
    check(.dot)
    let field = nameExpr()
    return DotExpr(left, field, tok.pos)
  }

  func basicTupleExpr<T>(_ exprFunc: () -> T) -> [T] {
    var res: [T] = []
    while true {
      if [.rpar, .eof].contains(tok.kind) {
        break
      }
      res.append(exprFunc())
      if !isTok(.comma) {
        break
      }
      check(.comma)
    }
    return res
  }

  func indexExpr(_ left: Expr) -> IndexExpr {
    let pos = tok.pos
    check(.lsbr)
    let fieldExpr = expr()
    check(.rsbr)
    return IndexExpr(left, fieldExpr, pos)
  }

  func nameExpr() -> NameExpr {
    let pos = tok.pos
    let name = check(.name)
    let expr = NameExpr(name: name, pos: pos)
    return expr
  }

  func callExpr(_ left: Expr) -> Expr {
    let pos = left
    let args = tupleExpr()
    return CallExpr(left, args, pos)
  }

  func ifElseExpr(_ left: Expr) -> IfElseExpr {
    let pos = left
    check(.question)
    let truePart = expr()
    check(.colon)
    let falsePart = expr()
    return IfElseExpr(left, truePart, falsePart, pos)
  }
}
