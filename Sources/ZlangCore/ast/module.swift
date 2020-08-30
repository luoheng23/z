
class Module: Ast {
    var stmts: [Stmt]

    init(_ stmts: [Stmt]) {
        self.stmts = stmts
        super.init()
    }

    override func str() -> String {
        var str = stmts.map { stmt in stmt.str()
        }.joined(separator: "\n")
        str = "\(node)(\(str))"
        return str
    }

    override func text() -> String {
        let str = stmts.map { stmt in stmt.text()
        }.joined(separator: "\n")
        return str
    }

    override func gen() -> String {
        let str = stmts.map { stmt in stmt.gen()
        }.joined(separator: "\n")
        return str
    }
    
}