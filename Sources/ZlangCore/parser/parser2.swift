
class Parser {

    static var limitedErrors = 1
    static var limitedWarnings = 1

    var filePath: String
    
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

    var comments: CommentStmt? = nil

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
            check(.unknown, true)
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

    @discardableResult
    func check(_ expected: Kind, _ skip: Bool = false) -> Token {
        if !skip && !isTok(expected) {
            error("unexpected token '\(tok.text())', expecting '\(expected.text())'")
            return Token()
        }
        next()
        return preTok
    }

    func isTok(_ expected: Kind) -> Bool {
        return tok.kind == expected
    }

    func isNextTok(_ expected: Kind) -> Bool {
        return peekTok.kind == expected
    }
}