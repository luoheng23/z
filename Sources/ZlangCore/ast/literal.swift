
class Literal: Expr {
    let val: String

    init(_ val: String, _ pos: Position) {
        self.val = val
        super.init(pos)
    }
    
    override func str() -> String {
        return "\(node)(\(text()))"
    }
    override func text() -> String {
        return val
    }
}

class NoneLiteral: Literal {}

class BoolLiteral: Literal {}

class FloatLiteral: Literal {}

class IntegerLiteral: Literal {}

class StringLiteral: Literal {}