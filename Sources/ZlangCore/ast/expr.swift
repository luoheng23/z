
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

