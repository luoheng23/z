
class BlockStmt: Stmt {
    var stmts: [Stmt]
    
    init(stmts: [Stmt], _ pos: Position) {
        self.stmts = stmts
        super.init(pos)
    }

    override init() {
        self.stmts = []
        super.init()
    }
    func append(_ stmt: Stmt) {
        stmts.append(stmt)
    }

    override func str() -> String {
        var str = stmts.map { stmt in "    " + stmt.str() }.joined(separator: "\n")
        if stmts.count != 0 {
            str  = "\n\(str)\n"
        }
        str = "\(node)({\(str)})"
        return str
    }

    override func text() -> String {
        var str = stmts.map { stmt in "    " + stmt.text() }.joined(separator: "\n")
        if stmts.count != 0 {
            str  = "\n\(str)\n"
        }
        str = "\(node)({\(str)})"
        return str
    }
}

class ExprStmt: Stmt {
    var expr: Expr

    init(_ expr: Expr, _ pos: Position) {
        self.expr = expr
        super.init(pos)
    }
}

class ForStmt: Stmt {
    var cond: Expr = Expr()
    var isInf: Bool = false
    var block: BlockStmt = BlockStmt()
}

class ForInStmt: Stmt {
    var key: String = ""
    var value: String = ""
    var block: BlockStmt = BlockStmt()

}

class AssignStmt: Stmt {
    var left: [Expr] = []
    var right: [Expr] = []
    var op: Kind = .plus
    var leftTypes: [Type] = []
    var rightTypes: [Type] = []
}

// class DeferStmt: Stmt {
//     var blockStmt: BlockStmt

//     init(stmts: BlockStmt, _ pos: Position) {
//         self.stmts = stmts
//         super.init()
//     }
// }

class GoStmt: Stmt {
    var callExpr: Expr

    init(_ callExpr: Expr, _ pos: Position) {
        self.callExpr = callExpr
        super.init(pos)
    }
}

class WithStmt: Stmt {
    var stmt: AssignStmt
    var block: BlockStmt

    init(_ stmt: AssignStmt, _ block: BlockStmt, _ pos: Position) {
        self.stmt = stmt
        self.block = block
        super.init(pos)
    }
}

class SwitchStmt: Stmt {
    var tok: Kind = .plus
    var branches: [SwitchBranch] = []
}

class SwitchBranch: Stmt {
    var exprs: [Expr] = []
    var stmts: [Stmt] = []
}

class IfStmt: Stmt {
    var tok: Kind = .plus
    var branches: [IfBranch] = []
}

class IfBranch: Stmt {
    var cond: Expr = Expr()
    var block: BlockStmt = BlockStmt()
}

class BranchStmt: Stmt {
    var tok: Token

    init(tok: Token) {
        self.tok = tok
        super.init()
    }
}

class ReturnStmt: Stmt {
    var expr: Expr = Expr()
}

class CommentStmt: Stmt {}