extension Parser {
  func stmt(_ isTopLevel: Bool = false) -> Stmt {
    var node: Stmt
    switch tok.kind {
    case .lcbr:
      node = blockStmt()
    case .key_const, .key_var, .key_func, .key_struct, .key_enum, .key_interface, .key_impl,
      .key_type:
      node = decl()
    case .comment:
      node = commentStmt()
    case .key_defer:
      node = deferStmt()
    case .key_go:
      node = goStmt()
    case .key_return:
      node = returnStmt()
    case .key_import:
      node = importStmt()
    case .key_with:
      node = withStmt()
    case .key_continue, .key_break, .key_fallthrough:
      node = branchStmt()
    case .key_for:
      node = forStmt()
    case .key_if:
      node = ifStmt()
    case .key_switch:
      node = switchStmt()
    default:
      node = exprStmt()
    }
    return node
  }

  func exprStmt() -> Stmt {
    let pos = tok.pos
    let left = expr()
    if !tok.kind.isAssign() {
      pos.addPosition(left)
      return ExprStmt(left, pos)
    }
    let op = tok.kind
    check(op)
    let right = expr()
    pos.addPosition(right)
    return AssignStmt(left, op, right, pos)
  }

  func blockStmt() -> BlockStmt {
    return parseBlockNoScope()
  }

  func parseBlockNoScope(_ isTopLevel: Bool = false) -> BlockStmt {
    let pos = tok.pos
    check(.lcbr)
    var stmts: [Stmt] = []
    if tok.kind != .rcbr {
      var c = 0
      while (true) {
        stmts.append(stmt())
        if [.eof, .rcbr].contains(tok.kind) {
          break
        }
        c += 1
        if c > 1_000_000 {
          errorWithPos(
            "parsed over \(c) statements from fn \(curFnName), the parser is probably stuck",
            tok.pos)
        }
      }
    }
    pos.addPosition(tok.pos)
    check(.rcbr)
    return BlockStmt(stmts: stmts, pos)
  }

  func branchStmt() -> BranchStmt {
      switch (tok.kind) {
      case .key_break:
        let name = check(.key_break)
        return BreakStmt(name.lit, name.pos)
      case .key_continue:
        let name = check(.key_continue)
        return ContinueStmt(name.lit, name.pos)
      case .key_fallthrough:
        let name = check(.key_fallthrough)
        return FallthroughStmt(name.lit, name.pos)
      default:
        error("unreachable code")
        return BranchStmt("", tok.pos)
      }
  }

  func forStmt() -> ForStmt {
    let pos = tok.pos
    check(.key_for)
    var cond: Expr? = nil
    if !isTok(.lcbr) {
      cond = expr()
    }
    let block = blockStmt()
    pos.addPosition(block)
    if let c = cond {
      return ForStmt(c, block, pos)
    }
    return ForStmt(block, pos)
  }

  func importStmt() -> Stmt {
    let pos = tok.pos
    check(.key_import)
    let name = nameExpr()
    pos.addPosition(name)
    return ImportStmt(name, pos)
  }

  func withStmt() -> WithStmt {
    let pos = tok.pos
    check(.key_with)
    let namedecl = nameDecl()
    let block = blockStmt()
    pos.addPosition(block)
    return WithStmt(namedecl, block, pos)
  }

  func goStmt() -> Stmt {
    let pos = tok.pos
    check(.key_go)
    let expr = self.expr()
    pos.addPosition(expr)
    return GoStmt(expr, pos)
  }

  func returnStmt() -> ReturnStmt {
    let pos = tok.pos
    check(.key_return)
    let expr = self.expr()
    pos.addPosition(expr)
    return ReturnStmt(expr, pos)
  }

  func deferStmt() -> DeferStmt {
      let pos = tok.pos
      check(.key_defer)
      let expr = self.expr()
      pos.addPosition(expr)
      return DeferStmt(expr, pos)
  }

  func commentStmt() -> CommentStmt {
      let pos = tok.pos
      var comments: [String] = []
      while isTok(.comment) {
          comments.append(check(.comment).lit)
      }
      pos.addPosition(preTok.pos)
      return CommentStmt(comments, pos)
  }

  func ifStmt() -> IfStmt {
    let pos = tok.pos
    check(.key_if)
    let cond = expr()
    let trueBlock = blockStmt()
    if !isTok(.key_else) {
      pos.addPosition(trueBlock)
      return IfStmt(cond, trueBlock, pos)
    }
    check(.key_else)
    var falseBlock: IfStmt
    if isTok(.key_if) {
      falseBlock = ifStmt()
      pos.addPosition(falseBlock)
      return IfStmt(cond, trueBlock, falseBlock, pos)
    }
    let block = blockStmt()
    pos.addPosition(block)
    falseBlock = IfStmt(block, pos)
    return IfStmt(cond, trueBlock, falseBlock, pos)
  }


  func switchStmt() -> Stmt {
    let pos = tok.pos
    check(.key_switch)
    let cond = expr()
    check(.lcbr)
    var branches: [SwitchBranch] = []
    while !isTok(.rcbr) && !isTok(.eof) {
      let pos = tok.pos
      if isTok(.key_case) {
        check(.key_case)
        let cond = expr()
        let block = blockStmt()
        pos.addPosition(block)
        branches.append(SwitchBranch(cond, block, pos))
      } else if isTok(.key_default) {
        check(.key_default)
        let block = blockStmt()
        pos.addPosition(block)
        branches.append(SwitchBranch(block, pos))
      }
    }
    pos.addPosition(tok.pos)
    check(.rcbr)
    return SwitchStmt(cond, branches, pos)
  }

  func stmts() -> Module {
    var stmts: [Stmt] = []
    while !isTok(.eof) {
      stmts.append(stmt())
    }
    return Module(stmts)
  }
}
