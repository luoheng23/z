
class SelectorExpr: Expr {
    var expr: Expr
    var fieldName: String = ""

    init(_ expr: Expr, _ fieldName: String, _ pos: Position) {
        self.expr = expr
        self.fieldName = fieldName
        super.init(pos)
    }

    override func str() -> String {
        return "SelectorExpr(\(expr.str()).\(fieldName))"
    }

    override func text() -> String {
        return "\(expr.text()).\(fieldName)"
    }
}

class IndexExpr: Expr {
    var expr: Expr
    var fieldExpr: Expr

    init(_ expr: Expr, _ fieldExpr: Expr, _ pos: Position) {
        self.expr = expr
        self.fieldExpr = fieldExpr
        super.init(pos)
    }

    override func str() -> String {
        return "IndexExpr(\(expr.str())[\(fieldExpr.str())])"
    }

    override func text() -> String {
        return "\(expr.text())[\(fieldExpr.text())]"
    }
}







class CallExpr: Expr {
    var left: Expr = Expr()
    var mod: String = ""

    var name: String = ""
    var isMethod: Bool = false
    var isField: Bool = false
    var args: [CallArg] = []
    var expectedArgTypes: [Type] = []
}

class CallArg {
    var isVar: Bool = false
    var expr: Expr = Expr()
}

class Comment: Expr {
    var comment: String

    override init() {
        self.comment = ""
        super.init()
    }

    init(text: String, pos: Position) {
        self.comment = text
        super.init(pos)
    }

    override func str() -> String {
        return "Comment(\(comment))"
    }

    override func text() -> String {
        return "\(comment)"
    }
}

class None: Expr {
    init(pos: Position) {
        super.init(pos)
    }

    override func str() -> String {
        return "None(nil)"
    }

    override func text() -> String {
        return "nil"
    }
}

class EnumVal: Expr {
    var val: String

    init(val: String, pos: Position, associatedValue: String = "") {
        self.val = val
        super.init(pos)
    }

    override func str() -> String {
        return "EnumVal(.\(val))"
    }

    override func text() -> String {
        return ".\(val)"
    }
}

class Tuple: Expr {
    var exprs: [Expr]

    init(_ exprs: [Expr], _ pos: Position) {
        self.exprs = exprs
        super.init(pos)
    }

    override func str() -> String {
        var str = exprs.map { expr in
            return expr.str()
        }.joined(separator: ",")
        str = "(" + str + ")"
        return "Tuple(" + str + ")"
    }

    override func text() -> String {
        let str = exprs.map { expr in
            return expr.text()
        }.joined(separator: ",")
        return "(" + str + ")"
    }
}

class PrefixExpr: Expr {
    var op: Kind
    var right: Expr

    init(op: Kind, right: Expr, _ pos: Position) {
        self.op = op
        self.right = right
        super.init(pos, [], right.type ?? Var(""))
    }

    override func str() -> String {
        return "PrefixExpr(\(op.rawValue)\(right.str()))"
    }

    override func text() -> String {
        return "\(op.rawValue)\(right.text())"
    }
}

class NameExpr: Expr {
    var name: String

    init(name: String, pos: Position) {
        self.name = name
        super.init(pos, [])
    }

    override func str() -> String {
        return "NameExpr(\(name))"
    }

    override func text() -> String {
        return "\(name)"
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
        super.init(pos, [], right.type ?? Var(""))
    }

    override func str() -> String {
        return "InfixExpr(\(left.str())\(op.rawValue)\(right.str()))"
    }

    override func text() -> String {
        return "\(left.text())\(op.rawValue)\(right.text())"
    }
}