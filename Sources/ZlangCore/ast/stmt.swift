
class BlockStmt: Stmt {
    var stmts: [Stmt] = []
    
    func append(_ stmt: Stmt) {
        stmts.append(stmt)
    }
}

class ExprStmt: Stmt {
    var expr: Expr = Expr()
    var isExpr: Bool = false
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

    var keyType: Type = ._nil
    var valueType: Type = ._nil
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
}

class GoStmt: Stmt {
    var callExpr: Expr = Expr()
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

class ReturnStmt: Stmt {
    var expr: Expr = Expr()
    var returnType: Type = ._nil
}

