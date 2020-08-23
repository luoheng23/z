
class Parser2 {
    var fileName: String = ""
    var fileNameDir: String = ""
    
    var scanner: Scanner = Scanner("")
    var tok: Token = Token()
    var preTok: Token = Token()
    var peekTok: Token = Token()
    var peekTok2: Token = Token()
    var peekTok3: Token = Token()

    var table: Table = Table()

    var curFnName: String = ""
    var mod: String = ""
    var scope: Scope = Scope()
    var globalScope: Scope = Scope()
    var imports: Dictionary<String, String> = [:]
    var errors: Error = Error()
    var warnings: Warning = Warning()

    var fnName: String = ""

    init(filename: String) {}

    func readFirstToken() {
        for _ in 1...4 {
            p.next()
        }
    }

    func openScope() {
        scope = Scope(parent: scope, startPos: tok.pos)
    }

    func closeScope() {
        scope.endPos = prevTok.pos
        scope.parent.children.append(scope)
        scope = scope.parent
    }

    func parseBlock() -> [Stmt] {
        openScope()
        let stmts = parseBlockNoScope(false)
        closeScope()
        return stmts
    }

    func parseBlockNoScope(_ isTopLevel: Bool) -> [Stmt] {
        check(.lcbr)
        var stmts: [Stmt] = []
        if tok.kind != .rcbr {
            var c = 0
            while (true) {
                stmts.append(stmt(isTopLevel))
                if [.eof, .rcbr].contains(tok.kind) {
                    break
                }
                c += 1
                if c > 1000000 {
                    errorWithPos("parsed over \(c) statements from fn \(curFnName), the parser is probably stuck", 
                                    tok.pos())
                }
            }
        }

        if isTopLevel {
            topLevelStatementEnd()
        }
        check(.rcbr)
        return stmts
    }

    func next() {
        preTok = tok
        tok = peekTok
        peekTok = peekTok2
        peekTok2 = peekTok3
        peekTok3 = scanner.scan()
    }

    func check(_ expected: Kind) {
        if tok.kind != expected {
            if tok.kind == .name {
                error("unexpected name \(tok.lit), expecting \(expected.str())")
            } else {
                error("unexpected \(tok.kind.str()), expecting \(expected.str())")
            }
        }
        p.next()
    }

    func checkName() -> String {
        let name = tok.lit
        if peekTok.kind == .dot && imports.contains(name) {
            registerUsedImport(name)
        }
        check(.name)
        return name
    }

    func topStmt() -> Stmt {
        switch (tok.kind) {
        case .key_pub:
            switch (peekTok.kind) {
            case .key_const:
                return const_decl()
            case .key_fn:
                return fn_decl()
            case .key_struct:
                return struct_decl()
            case .key_enum:
                return enum_decl()
            case .key_interface:
                return interface_decl()
            case .key_impl:
                return impl_decl()
            case .key_type:
                return type_decl()
            default:
                error("wrong pub keyword usage")
                return Stmt()
            }
        case .key_interface:
            return interface_decl()
        case .key_impl:
            return impl_decl()
        case .key_import:
            errorWithPos("import can only be declared at the beginning of the file", tok.pos)
            return import_stmt()
        case .key_const:
            return const_decl()
        case .key_fn:
            return fn_decl()
        case .struct_decl:
            return struct_decl()
        case .key_type:
            return type_decl()
        case .comment:
            return commentStmt()
        default:
            error("bad top level statement " + p.tok.str())
        }
        return Stmt()
    }

    func checkComment() -> Comment {
        if tok.kind == .comment {
            return comment()
        }
        return Comment()
    }

    func comment() -> Comment {
        let pos = tok.pos
        let text = tok.lit
        p.next()
        return 
        return Comment(text: text, pos: pos)
    }

    func commentStmt() -> ExprStmt {
        let comment = comment()
        return ExprStmt(expr: comment, pos: comment.pos)
    }

    func allComments() -> [Comment] {
        var comments: [Comment] = []
        while tok.kind == .comment {
            comments.append(comment())
        }
        return comments
    }

    func stmt(_ isTopLevel: Bool) {
        switch(tok.kind) {
        case .lcbr:
            return Block(stmts: parseBlock())
        case .key_for:
            return forStmt()
        case .key_static, .key_fn:
            return fn_decl()
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
            let expr = self.expr(0)
            return GoStmt(callExpr: expr)
        case .key_const:
            return const_decl()
        case .key_var:
            return var_decl()
        default:
            return parseMultiExpr(isTopLevel)
        }
    }

    func exprList() -> ([Expr], [Comment]) {
        var exprs: [Expr] = []
        var comments: [Comment] = []
        while (true) {
            let expr = self.expr(0)
            if expr is Comment {
                comments.append(expr)
            } else {
                exprs.append(expr)
                if kind != .comma {
                    break
                }
                next()
            }
        }
        return exprs, comments
    }

    func error(_ str: String) {
        errorWithPos(str, tok.pos)
    }

    func warn(_ str: String) {
        warnWithPos(str, tok.pos)
    }

    func errorWithPos(_ str: String, _ pos: Position) {
        fatalError(str + pos.str())
    }
}