extension Parser {
    func stmt(_ isTopLevel: Bool = false) -> Stmt {
        switch(tok.kind) {
        case .lcbr:
            return blockStmt()
        case .key_for:
            return forStmt()
        case .key_const, .key_var, .key_func, .key_struct, .key_enum, .key_interface, .key_impl,    
                .key_type:
            return decl()
        case .comment:
            return commentStmt()
        case .key_return:
            return returnStmt()
        case .key_continue, .key_break:
            let tok = self.tok
            next()
            return BranchStmt(tok: tok)
        // case .key_defer:
        //     next()
        //     return DeferStmt(stmts: blockStmt(), )
        case .key_go:
            next()
            let expr = self.expr()
            return GoStmt(callExpr: expr)
        default:
            return Stmt()
        }
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
}