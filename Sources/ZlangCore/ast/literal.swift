
class Literal: Expr {
    var defaultType: Var

    init(_ pos: Position, _ defaultType: Var) {
        self.defaultType = defaultType
        super.init(pos)
    }
}

class BoolLiteral: Literal {
    var bool: Bool

    init(bool: Bool, _ pos: Position, _ type: Var) {
        self.bool = bool
        super.init(pos, type)
    }

    override func str() -> String {
        return "BoolLiteral(\(text()))"
    }

    override func text() -> String {
        return bool ? "true" : "false"
    }


}

class FloatLiteral: Literal {
    var val: String

    init(val: String, _ pos: Position, _ type: Var) {
        self.val = val
        super.init(pos, type)
    }

    override func str() -> String {
        return "FloatLiteral(\(val))"
    }

    override func text() -> String {
        return val
    }
}

class IntegerLiteral: Literal {
    var val: String

    init(val: String, _ pos: Position, _ type: Var) {
        self.val = val
        super.init(pos, type)
    }

    override func str() -> String {
        return "IntegerLiteral(\(val))"
    }

    override func text() -> String {
        return val
    }


}

class StringLiteral: Literal {
    var val: String

    init(val: String, _ pos: Position, _ type: Var) {
        self.val = val
        super.init(pos, type)
    }

    override func str() -> String {
        return "StringLiteral(\(val))"
    }

    override func text() -> String {
        return val
    }
}