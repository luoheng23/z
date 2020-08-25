
class BlockStmt: Stmt {
    var stmts: [Stmt]
    
    init(stmts: [Stmt]) {
        self.stmts = stmts
        super.init()
    }

    override init() {
        self.stmts = []
        super.init()
    }
    func append(_ stmt: Stmt) {
        stmts.append(stmt)
    }
}

class ExprStmt: Stmt {
    var expr: Expr = Expr()
    var isComment: Bool
    init(expr: Expr, isComment: Bool) {
        self.expr = expr
        self.isComment = isComment
        super.init()
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

class DeferStmt: Stmt {
    var stmts: [Stmt] = []

    init(stmts: [Stmt]) {
        self.stmts = stmts
        super.init()
    }
}

class GoStmt: Stmt {
    var callExpr: Expr = Expr()

    init(callExpr: Expr) {
        self.callExpr = callExpr
        super.init()
    }
}

class WithStmt: Stmt {
    var stmt: AssignStmt = AssignStmt()
    var block: BlockStmt = BlockStmt()
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

