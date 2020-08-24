class BoolLiteral: Expr {
    var bool: Bool

    override init() {
        self.bool = true
        super.init()
    }

    init(bool: Bool, _ pos: Position) {
        self.bool = bool
        super.init(pos, [])
    }

    override func str() -> String {
        return bool ? "true" : "false"
    }
}

class FloatLiteral: Expr {
    var val: String

    init(val: String, _ pos: Position) {
        self.val = val
        super.init(pos, [])
    }

    override func str() -> String {
        return val
    }
}

class IntegerLiteral: Expr {
    var val: String

    init(val: String, _ pos: Position) {
        self.val = val
        super.init(pos, [])
    }

    override func str() -> String {
        return val
    }
}