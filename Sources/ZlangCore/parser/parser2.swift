
class Parser {
    var filePath: String
    var fileNameDir: String = ""
    
    var scanner: Scanner
    var tok: Token = Token()
    var preTok: Token = Token()
    var peekTok: Token = Token()
    var peekTok2: Token = Token()
    var peekTok3: Token = Token()

    var curFnName: String = ""

    var mod: String = ""
    var scope: Scope = Scope()
    var globalScope: Scope = Scope(true)

    var errors: Error = Error()
    var warnings: Warning = Warning()

    var comments: [Comment] = []

    var fnName: String = ""

    init(filePath: String) {
        self.filePath = filePath
        self.scanner = Scanner(filePath: filePath)
    }

    init(str: String) {
        self.filePath = ""
        self.scanner = Scanner(str)
    }

    func readFirstToken() {
        for _ in 1...4 {
            next()
        }
    }

    func openScope() {
        scope = Scope(parent: scope, pos: tok.pos)
    }

    func closeScope() {
        if scope.isTopScope {
            error("failed to close global scope")
            return
        }
        scope.pos.addPosition(preTok.pos)
        scope.parent!.children.append(scope)
        scope = scope.parent!
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
                                    tok.pos)
                }
            }
        }

        if isTopLevel {
            // topLevelStatementEnd()
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
        next()
    }

    func checkName() -> String {
        let name = tok.lit
        if peekTok.kind == .dot && imports[name] != nil {
            // registerUsedImport(name)
        }
        check(.name)
        return name
    }

    func topStmt() -> Stmt {
        switch (tok.kind) {
        case .key_pub:
            switch (peekTok.kind) {
            case .key_const:
                return constDecl()
            case .key_func:
                return fnDecl()
            case .key_struct:
                return structDecl()
            case .key_enum:
                return enumDecl()
            case .key_interface:
                return interfaceDecl()
            case .key_impl:
                return implDecl()
            case .key_type:
                return typeDecl()
            default:
                error("wrong pub keyword usage")
                return Stmt()
            }
        case .key_interface:
            return interfaceDecl()
        case .key_impl:
            return implDecl()
        case .key_import:
            errorWithPos("import can only be declared at the beginning of the file", tok.pos)
            return importStmt()
        case .key_const:
            return constDecl()
        case .key_enum:
            return enumDecl()
        case .key_func:
            return fnDecl()
        case .key_struct:
            return structDecl()
        case .key_type:
            return typeDecl()
        case .comment:
            return commentStmt()
        default:
            error("bad top level statement " + tok.str())
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
        next()
        return Comment(text: text, pos: pos)
    }

    func commentStmt() -> ExprStmt {
        let comment = self.comment()
        return ExprStmt(expr: comment, isComment: true)
    }

    func allComments() -> [Comment] {
        var comments: [Comment] = []
        while tok.kind == .comment {
            comments.append(comment())
        }
        return comments
    }

    func stmt(_ isTopLevel: Bool) -> Stmt {
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
            let expr = self.expr(0)
            return GoStmt(callExpr: expr)
        case .key_const:
            return constDecl()
        case .key_var:
            return varDecl()
        default:
            return parseMultiExpr(isTopLevel)
        }
    }

    func exprList() -> [Expr] {
        var exprs: [Expr] = []
        while (true) {
            let expr = self.expr()
            exprs.append(expr)
            if tok.kind != .comma {
                break
            }
            next()
        }
        return exprs
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

    func warnWithPos(_ str: String, _ pos: Position) {}

    func parseMultiExpr(_ isTopLevel: Bool) -> Stmt {
        return Stmt()
    }
    
    func constDecl() -> Stmt {
        // let startPos = tok.pos
        // let isPub = tok.kind == .key_pub
        // if isPub {
        //     next()
        // }
        // var endPos = tok.pos
        // check(.key_const)
        // switch(tok.kind) {
        // case .name:
        //     next()
        //     switch(tok.kind) {
        //     case .colon:
        //         let type = self.expr()

        //     }
        // }
        return Stmt()
    }

    func varDecl() -> Stmt {
        return Stmt()
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

    func fnDecl() -> Stmt {
        return Stmt()
    }

    func structDecl() -> Stmt {
        return Stmt()
    }

    func typeDecl() -> Stmt {
        return Stmt()
    }

    func importStmt() -> Stmt {
        return Stmt()
    }

    func enumDecl() -> Stmt {
        return Stmt()
    }

    func interfaceDecl() -> Stmt {
        return Stmt()
    }

    func implDecl() -> Stmt {
        return Stmt()
    }
}