
class ForStmt: Stmt {
    var cond: Expr?
    var block: BlockStmt

    init(_ cond: Expr, _ block: BlockStmt, _ pos: Position) {
        self.cond = cond
        self.block = block
        super.init(pos)
    }

    init(_ block: BlockStmt, _ pos: Position) {
        self.cond = nil
        self.block = block
        super.init(pos)
    }

    override func str() -> String {
        var str = "for "
        if let c = cond {
            str += "\(c.str()) "
        }
        str += block.str()
        str = "\(node)(\(str))"
        return str
    }

    override func text() -> String {
        var str = "for "
        if let c = cond {
            str += "\(c.text()) "
        }
        str += block.text()
        return str
    }
}

class AssignStmt: Stmt {
    var left: Expr
    var op: Kind
    var right: Expr


    init(_ left: Expr, _ op: Kind, _ right: Expr, _ pos: Position) {
        self.left = left
        self.op = op
        self.right = right
        super.init(pos)
    }

    override func str() -> String {
        return "\(node)(\(left.str()) \(op.str()) \(right.str()))"
    }

    override func text() -> String {
        return "\(left.text()) \(op.text()) \(right.text())"
    }


}

class SwitchStmt: Stmt {
    var cond: Expr
    var branches: [SwitchBranch]

    init(_ cond: Expr, _ branches: [SwitchBranch], _ pos: Position) {
        self.cond = cond
        self.branches = branches
        super.init(pos)
    }

    override func str() -> String {
        if branches.count == 0 {
            return "\(node)(switch \(cond.str()) {})"
        }
        var str = "switch \(cond.str()) {\n"
        str += branches.map { branch in branch.str()}.joined(separator: "\n")
        str += "\n}"
        str = "\(node)(\(str))"
        return str
    }

    override func text() -> String {
        if branches.count == 0 {
            return "switch \(cond.text()) {}"
        }
        var str = "switch \(cond.text()) {\n"
        str += branches.map { branch in branch.text()}.joined(separator: "\n")
        str += "\n}"
        str = "\(str)"
        return str
    }
}

class SwitchBranch: Stmt {
    var cond: Expr?
    var block: BlockStmt

    init(_ cond: Expr, _ block: BlockStmt, _ pos: Position) {
        self.cond = cond
        self.block = block
        super.init(pos)
    }

    init(_ block: BlockStmt, _ pos: Position) {
        self.block = block
        self.cond = nil
        super.init(pos)
    }

    override func str() -> String {
        var str: String = ""
        if let c = cond {
            str = "case \(c.str()) "
        } else {
            str = "default "
        }
        str += block.str()
        str = "\(node)(\(str))"
        return str
    }

    override func text() -> String {
        var str: String = ""
        if let c = cond {
            str = "case \(c.text()) "
        } else {
            str = "default "
        }
        str += block.text()
        str = "\(str)"
        return str
    }
}

class IfStmt: Stmt {
    var cond: Expr?
    var trueBlock: BlockStmt
    var falseBlock: IfStmt?

    init(_ cond: Expr, _ trueBlock: BlockStmt, _ falseBlock: IfStmt, _ pos: Position) {
        self.cond = cond
        self.trueBlock = trueBlock
        self.falseBlock = falseBlock
        super.init(pos)
    }

    init(_ cond: Expr, _ trueBlock: BlockStmt, _ pos: Position) {
        self.cond = cond
        self.trueBlock = trueBlock
        self.falseBlock = nil
        super.init(pos)
    }

    init(_ trueBlock: BlockStmt, _ pos: Position) {
        self.cond = nil
        self.trueBlock = trueBlock
        self.falseBlock = nil
        super.init(pos)
    }

    override func str() -> String {
        var str: String = ""
        if let c = cond {
            str = "if \(c.str()) "
        }
        str += trueBlock.str()
        if let f = falseBlock {
            str += " else \(f.str())"
        }
        str = "\(node)(\(str))"
        return str
    }

    override func text() -> String {
        var str: String = ""
        if let c = cond {
            str = "if \(c.text()) "
        }
        str += trueBlock.text()
        if let f = falseBlock {
            str += " else \(f.text())"
        }
        return str
    }
}

class BranchStmt: Stmt {
    var name: String = ""

    init(_ name: String, _ pos: Position) {
        self.name = name
        super.init(pos)
    }

    override func str() -> String {
        return "\(node)(\(name))"
    }

    override func text() -> String {
        return "\(name)"
    }
}

class BreakStmt: BranchStmt {
    override var name: String { get { "break" } set {} }
}

class ContinueStmt: BranchStmt {
    override var name: String { get { "continue" } set {} }
}

class FallthroughStmt: BranchStmt {
    override var name: String { get { "fallthrough" } set {} }
}

class ImportStmt: Stmt {
    var name: NameExpr

    init(_ name: NameExpr, _ pos: Position) {
        self.name = name
        super.init(pos)
    }

    override func str() -> String {
        return "\(node)(import \(name.str()))"
    }

    override func text() -> String {
        return "import \(name.text())"
    }
}

class WithStmt: Stmt {
    var namedecl: NameDecl
    var block: BlockStmt

    init(_ namedecl: NameDecl, _ block: BlockStmt, _ pos: Position) {
        self.namedecl = namedecl
        self.block = block
        super.init(pos)
    }

    override func str() -> String {
        let str = "\(node)(with \(namedecl.str()) \(block.str()))"
        return str
    }

    override func text() -> String {
        let str = "with \(namedecl.text()) \(block.text())"
        return str
    }
}


class GoDeferReturnStmt: Stmt {
    var expr: Expr
    var stmtName: String = ""

    init(_ expr: Expr, _ pos: Position) {
        self.expr = expr
        super.init(pos)
    }

    override func str() -> String {
        return "\(node)(\(stmtName) \(expr.str()))"
    }

    override func text() -> String {
        return "\(stmtName) \(expr.text())"
    }
}

class GoStmt: GoDeferReturnStmt {
    override var stmtName: String { get { "go" } set {} }
}

class DeferStmt: GoDeferReturnStmt {
    override var stmtName: String { get { "defer" } set {} }
}

class ReturnStmt: GoDeferReturnStmt {
    override var stmtName: String { get { "return" } set {} }
}

class CommentStmt: Stmt {
    var comment: [String]

    init(_ comments: [String], _ pos: Position) {
        self.comment = comments
        super.init(pos)
    }

    override func str() -> String {
        let str = comment.joined(separator: "\n")
        return "\(node)(\(str))"
    }

    override func text() -> String {
        return comment.joined(separator: "\n")
    }
}

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
        str = "{\(str)}"
        return str
    }
}

class ExprStmt: Stmt {
    var expr: Expr

    init(_ expr: Expr, _ pos: Position) {
        self.expr = expr
        super.init(pos)
    }

    override func str() -> String {
        return "\(node)(\(expr.str()))"
    }

    override func text() -> String {
        return expr.text()
    }
}
