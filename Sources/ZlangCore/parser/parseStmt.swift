extension Parser {
    func stmt(_ isTopLevel: Bool = false) -> Stmt {
        switch(tok.kind) {
        case .lcbr:
            return BlockStmt(stmts: parseBlock())
        case .key_for:
            return forStmt()
        case .key_static, .key_func:
            return fnDecl()
        case .comment:
            return commentStmt()
        case .key_return:
            return returnStmt()
        case .key_continue, .key_break:
            let tok = self.tok
            next()
            return BranchStmt(tok: tok)
        case .key_defer:
            next()
            return DeferStmt(stmts: parseBlock())
        case .key_go:
            next()
            let expr = self.expr()
            return GoStmt(callExpr: expr)
        case .key_type:
            return typeDecl()
        case .key_const:
            return constDecl()
        case .key_var:
            return varDecl()
        case .key_struct:
            return structDecl()
        case .key_enum:
            return enumDecl()
        case .key_interface:
            return interfaceDecl()
        case .key_impl:
            return implDecl()
        default:
            return Stmt()
        }
    }

    
}