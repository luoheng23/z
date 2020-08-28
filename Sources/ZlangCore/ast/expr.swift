
// atom name
class NameExpr: Expr {
    var name: String

    init(name: String, pos: Position) {
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

class AtomExpr: Expr {
    var left: Expr
    var field: Expr

    init(_ left: Expr, _ field: Expr, _ pos: Position) {
        self.left = left
        self.field = field
        super.init(pos)
    }
}

class DotExpr: AtomExpr {
    override func str() -> String {
        return "\(node)(\(left.str()).\(field))"
    }

    override func text() -> String {
        return "\(left.text()).\(field)"
    }
}

class IndexExpr: AtomExpr {
    override func str() -> String {
        return "\(node)(\(left.str())[\(field.str())])"
    }

    override func text() -> String {
        return "\(left.text())[\(field.text())]"
    }
}

class CallExpr: AtomExpr {
    override func str() -> String {
        return "\(node)(\(left.str())\(field.str()))"
    }

    override func text() -> String {
        return "\(left.text())\(field.text())"
    }
}

class EnumValueExpr: Expr {
    var val: String

    init(val: String, pos: Position) {
        self.val = val
        super.init(pos)
    }

    override func str() -> String {
        return "\(node)(.\(val))"
    }

    override func text() -> String {
        return ".\(val)"
    }
}

class TupleExpr: Expr {
    var exprs: [Expr]

    var count: Int { exprs.count }

    override init() {
        self.exprs = []
        super.init()
    }

    init(_ exprs: [Expr], _ pos: Position) {
        self.exprs = exprs
        super.init(pos)
    }

    override func str() -> String {
        var str = exprs.map { expr in expr.str() }.joined(separator: ", ")
        return "\(node)((\(str)))"
    }

    override func text() -> String {
        let str = exprs.map { expr in expr.text() }.joined(separator: ", ")
        return "(\(str))"
    }
}

class PrefixExpr: Expr {
    var op: Kind
    var right: Expr

    init(op: Kind, right: Expr, _ pos: Position) {
        self.op = op
        self.right = right
        super.init(pos)
    }

    override func str() -> String {
        return "\(node)(\(op.str())\(right.str()))"
    }

    override func text() -> String {
        return "\(op.str())\(right.text())"
    }
}

class InfixExpr: Expr {
    var left: Expr
    var op: Kind
    var right: Expr

    init(left: Expr, right: Expr, op: Kind, pos: Position) {
        self.left = left
        self.op = op
        self.right = right
        super.init(pos)
    }

    override func str() -> String {
        return "\(node)(\(left.str())\(op.str())\(right.str()))"
    }

    override func text() -> String {
        return "\(left.text())\(op.str())\(right.text())"
    }
}

class IfElseExpr: Expr {
    var cond: Expr
    var trueBranch: Expr
    var falseBranch: Expr

    init(_ cond: Expr, _ trueBranch: Expr, _ falseBranch: Expr, _ pos: Position) {
        self.cond = cond
        self.trueBranch = trueBranch
        self.falseBranch = falseBranch
        super.init(pos)
    }

    override func str() -> String {
        return "\(node)(\(cond.str()) ? \(trueBranch.str()) : \(falseBranch.str()))"
    }

    override func text() -> String {
        return "\(cond.text()) ? \(trueBranch.text()) : \(falseBranch.text())"
    }
}