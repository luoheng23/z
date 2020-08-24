
class SelectorExpr: Expr {
    var expr: Expr = Expr()
    var fieldName: String = ""
    var exprType: Type = ._nil
    var returnType: Type = ._nil
}

class CallExpr: Expr {
    var left: Expr = Expr()
    var mod: String = ""

    var name: String = ""
    var isMethod: Bool = false
    var isField: Bool = false
    var args: [CallArg] = []
    var expectedArgTypes: [Type] = []
    var leftType: Type = ._nil
    var receiverType: Type = ._nil
    var returnType: Type = ._nil
}

class CallArg {
    var isVar: Bool = false
    var expr: Expr = Expr()
}

class Comment: Expr {
    var text: String

    override init() {
        self.text = ""
        super.init()
    }

    init(text: String, pos: Position) {
        self.text = text
        super.init()
    }
}

class BoolLiteral: Expr {
    var bool: Bool

    override init() {
        self.bool = true
        super.init()
    }

    init(bool: Bool, _ comments: [Comment], _ pos: Position) {
        self.bool = bool
        super.init(pos, comments, .bool)
    }
}

class None: Expr {
    init(pos: Position) {
        super.init(pos, [], ._nil)
    }
}