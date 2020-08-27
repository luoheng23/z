
extension Parser {
    func expr(_ precedence: Int = 0) -> Expr {
        var node: Expr
        switch(tok.kind) {
        case .key_true, .key_false:
            node = BoolLiteral(bool: tok.kind == .key_true, tok.pos, scope.find(Type.bool.rawValue) as! Var)
            next()
        case .key_nil:
            node = None(pos: tok.pos)
        case .comment:
            node = self.comment()
        case .dot:
            node = enumVal()
        case .lpar:
            node = tupleExpr()
        case .string:
            node = stringExpr()
        case .name:
            node = nameExpr()
            if node is NameDeclareExpr {
                return node
            }
        case .key_func:
            node = funcExpr()
        case .number:
            node = numberExpr()
        case .minus, .plus, .amp, .mul, .key_not, .bit_not:
            node = prefixExpr()
        default:
            return Expr()
        }
        // Infix
        while precedence < tok.precedence() {
            switch (tok.kind) {
            case .dot:
                node = dotExpr(node)
            case .lsbr:
                node = indexExpr(node)
            case .lcbr:
                node = callExpr(node)
            default:
                if tok.isInfix() {
                    node = infixExpr(node)
                }
                else {
                    return node
                }
            }
        }
        return node
    }

    func stringExpr() -> StringLiteral {
        let node = StringLiteral(val: tok.lit, tok.pos, scope.find(Type.string.rawValue) as! Var)
        next()
        return node
    }

    func numberExpr() -> Literal {
        var node: Literal
        if tok.lit.contains(where: [".", "e", "E", "p", "P"].contains) {
            node = FloatLiteral(val: tok.lit, tok.pos, scope.find(Type.double.rawValue) as! Var)
        } else {
            node = IntegerLiteral(val: tok.lit, tok.pos, scope.find(Type.int.rawValue) as! Var)
        }
        next()
        return node
    }

    func enumVal() -> EnumVal {
        check(.dot)
        return EnumVal(val: checkName(), pos: tok.pos)
    }
    
    func tupleExpr() -> TupleExpr {
        let pos = tok.pos
        check(.lpar)
        let n = exprList()
        pos.addPosition(tok.pos)
        check(.rpar)
        return TupleExpr(n, pos)
    }

    func prefixExpr() -> PrefixExpr {
        let pos = tok.pos
        let op = tok.kind
        next()
        let right = expr(Precedence.pref.rawValue)
        return PrefixExpr(op: op, right: right, pos)
    }

    func infixExpr(_ left: Expr) -> Expr {
        let op = tok.kind
        let precedence = tok.precedence()
        let pos = tok.pos
        next()
        let right = expr(precedence)
        return InfixExpr(left: left, right: right, op: op, pos: pos)
    }

    func dotExpr(_ left: Expr) -> SelectorExpr {
        check(.dot)
        let fieldName = tok.lit
        next()
        return SelectorExpr(left, fieldName, tok.pos)
    }

    func indexExpr(_ left: Expr) -> IndexExpr {
        let pos = tok.pos
        check(.lsbr)
        let fieldExpr = expr()
        pos.addPosition(tok.pos)
        check(.rsbr)
        return IndexExpr(left, fieldExpr, pos)
    }

    func nameExpr() -> Expr {
        let pos = tok.pos
        let name = checkName()
        if tok.kind == .colon {
            let typeExpr = expr()
            return NameDeclareExpr(name, pos, typeExpr.type ?? Value(name))
        }
        let expr = NameExpr(name: name, pos: pos)
        return expr
    }

    func funcExpr() -> Expr {
        let pos = tok.pos
        return Expr(pos)
    }

    func callExpr(_ left: Expr) -> Expr {
        return Expr()
    }

    func exprList() -> [Expr] {
        var exprs: [Expr] = []
        while (true) {
            if tok.kind == .rpar || tok.kind == .eof {
                break
            }
            exprs.append(expr())
            if tok.kind != .comma {
                break
            }
            next()
        }
        return exprs
    }
}