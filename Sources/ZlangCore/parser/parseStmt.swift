extension Parser {
    func stmt(_ isTopLevel: Bool = false) -> Stmt {
        var node: Stmt
        switch(tok.kind) {
        case .lcbr:
            node = blockStmt()
        case .key_for:
            node = forStmt()
        case .key_const, .key_var, .key_func, .key_struct, .key_enum, .key_interface, .key_impl,
                .key_type:
            node = decl()
        case .comment:
            node = commentStmt()
        case .key_return:
            node = returnStmt()
        case .key_continue, .key_break:
            let tok = self.tok
            next()
            node = BranchStmt(tok: tok)
        // case .key_defer:
        //     next()
        //     return DeferStmt(stmts: blockStmt(), )
        case .key_go:
            node = goStmt()
        default:
            node = exprStmt()
        }
        return node
    }


    func exprStmt() -> Stmt {
        let pos = tok.pos
        let expr = self.expr()
        pos.addPosition(expr.pos)
        return ExprStmt(expr, pos)
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
                if c > 1000000 {
                    errorWithPos("parsed over \(c) statements from fn \(curFnName), the parser is probably stuck", 
                                    tok.pos)
                }
            }
        }
        pos.addPosition(tok.pos)
        check(.rcbr)
        return BlockStmt(stmts: stmts, pos)
    }

    func goStmt() -> Stmt {
        return Stmt()
    }

    func deferStmt() -> Stmt {
        return Stmt()
    }

    func returnStmt() -> Stmt {
        return Stmt()
    }

    func forStmt() -> Stmt {
        return Stmt()
    }


    func importStmt() -> Stmt {
        return Stmt()
    }

    func commentStmt() -> CommentStmt {
        return CommentStmt()
    }
}