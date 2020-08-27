
class Parser {

    static var limitedErrors = 20
    static var limitedWarnings = 20

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
    var scope: Scope
    var globalScope: Scope = Scope(true)

    var errors: [Error] = []
    var warnings: [Warning] = []

    var comments: [Comment] = []

    var fnName: String = ""

    init(filePath: String) {
        self.filePath = filePath
        self.scope = globalScope
        self.scanner = Scanner(filePath: filePath)
    }

    init(str: String) {
        self.filePath = ""
        self.scope = globalScope
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
        if scope === globalScope {
            fatalError("unexpected close global scope")
        }
        scope.pos.addPosition(preTok.pos)
        scope.parent!.children.append(scope)
        scope = scope.parent!
    }


    func next() {
        preTok = tok
        tok = peekTok
        peekTok = peekTok2
        peekTok2 = peekTok3
        peekTok3 = scanner.scan()
    }

    func eatToEndOfLine() {
        var scan = scanner.scan(false)
        while scan.kind != .nl && scan.kind != .eof {
            scan = scanner.scan(false)
        }
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
        check(.name)
        return name
    }

    func topStmt() -> Stmt {
        switch (tok.kind) {
        case .key_const, .key_var, .key_func, .key_struct, .key_enum, .key_interface, .key_impl,    
                .key_type:
            return decl()
        case .key_import:
            errorWithPos("import can only be declared at the beginning of the file", tok.pos)
            return importStmt()
        case .comment:
            return commentStmt()
        default:
            error("bad top level statement " + tok.str())
        }
        return Decl()
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

}