
extension Parser {
    func expr(_ precedence: Int = 0) -> Expr {
        var node: Expr
        switch(tok.kind) {
        case .key_true, .key_false:
            node = BoolLiteral(bool: tok.kind == .key_true, comments, tok.pos)
            next()
        case .key_nil:
            node = None(pos: tok.pos)
        case .string:
            node = stringExpr()
        default:
            return Expr()
        }
        return node
    }

    func stringExpr() -> Expr {
        
    }
    
}