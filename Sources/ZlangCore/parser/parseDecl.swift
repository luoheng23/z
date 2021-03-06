extension Parser {
    func decl() -> Decl {
        var node: Decl
        switch tok.kind {
        case .key_var, .key_let:
            node = varOrConstDecl()
        case .key_type:
            node = typeDecl()
        case .key_enum:
            node = enumDecl()
        case .key_case:
            node = enumValueDecl()
        case .key_struct:
            node = structDecl()
        case .key_interface:
            node = interfaceDecl()
        case .key_impl:
            node = implDecl()
        case .key_func:
            node = fnDecl()
        default:
            fatalError("invalid decl: \(tok.str())")
        // node = Decl()
        }
        return node
    }

    func basicNameDecl(_ annotationRequired: Bool = false)
        -> OneNameAnnotationDecl
    {
        let pos = tok.pos
        let name = nameExpr()
        var annotation: Expr? = nil
        if annotationRequired || isTok(.name) {
            annotation = nameExpr()
        }
        var defaultValue: Expr? = nil
        if isTok(.assign) {
            check(.assign)
            defaultValue = expr()
        }
        if let a = annotation {
            if let d = defaultValue {
                return OneNameAnnotationDecl(name, pos, a, d)
            }
            return OneNameAnnotationDecl(name, pos, a)
        }
        if let d = defaultValue {
            return OneNameAnnotationDecl(name, pos, defaultValue: d)
        }
        return OneNameAnnotationDecl(name, pos)
    }

    func nameDecl() -> NameDecl {
        let pos = tok.pos
        let isVar = isTok(.key_var)
        if isVar {
            check(.key_var)
        }
        else {
            check(.key_let)
        }
        let basicName = basicNameDecl(false)
        basicName.isVar = isVar
        return NameDecl(basicName, pos)
    }

    func argDecl(_ isReturn: Bool = false) -> ArgDecl {
        let pos = tok.pos
        let isVar = isTok(.key_var)
        if isVar {
            check(.key_var)
        }
        let basicName = basicNameDecl(!isReturn)
        basicName.isVar = isVar
        let decl = ArgDecl(basicName, pos)
        if isReturn {
            decl.isReturn = true
        }
        return decl
    }

    func enumValueDecl() -> EnumValueDecl {
        let pos = tok.pos
        check(.key_case)
        let name = nameExpr()
        return EnumValueDecl(name, pos)
    }

    func tupleArgDecl(_ isReturn: Bool = false) -> TupleArgDecl {
        let pos = tok.pos
        check(.lpar)
        let args = basicTupleExpr({ () -> ArgDecl in argDecl(isReturn) })
        check(.rpar)
        let tupleArgs = TupleArgDecl(args, pos)
        return tupleArgs
    }

    func tupleNameDecl() -> TupleNameDecl {
        let pos = tok.pos
        let isVar = isTok(.key_var)
        if isVar {
            check(.key_var)
        }
        else {
            check(.key_let)
        }
        check(.lpar)
        let left = basicTupleExpr({ () -> OneNameAnnotationDecl in
            basicNameDecl()
        })
        check(.rpar)
        var right: TupleExpr? = nil
        if isTok(.assign) {
            check(.assign)
            right = tupleExpr()
        }
        if let r = right {
            return TupleNameDecl(left, pos, r, isVar)
        }
        return TupleNameDecl(left, pos, isVar)
    }

    func varOrConstDecl() -> Decl {
        if isNextTok(.lpar) {
            return tupleNameDecl()
        }
        return nameDecl()
    }

    func typeDecl() -> TypeDecl {
        let pos = tok.pos
        check(.key_type)
        let name = nameExpr()
        let isAlias = isTok(.assign)
        if isAlias {
            check(.assign)
        }
        let type = expr()
        return TypeDecl(name, pos, type, isAlias)
    }

    func fnDecl() -> Decl {
        let pos = tok.pos
        check(.key_func)
        let name = nameExpr()
        let args = tupleArgDecl()
        var returns: Decl?
        if !isTok(.lcbr) {
            if isTok(.lpar) {
                returns = tupleArgDecl(true)
            }
            else {
                returns = argDecl(true)
            }
        }
        var blockStmt: BlockStmt?
        if isTok(.lcbr) {
            blockStmt = self.blockStmt()
        }
        if let b = blockStmt {
            if let r = returns {
                return FnDecl(name, pos, args, r, b)
            }
            return FnDecl(name, pos, args, body: b)
        }
        if let r = returns {
            return FnDecl(name, pos, args, r)
        }
        return FnDecl(name, pos, args)
    }

    func structDecl() -> StructDecl {
        let pos = tok.pos
        check(.key_struct)
        let name = nameExpr()
        let decls = blockDecls()
        return StructDecl(name, pos, decls)
    }

    func enumDecl() -> Decl {
        let pos = tok.pos
        check(.key_enum)
        let name = nameExpr()
        let decls = blockDecls()
        return EnumDecl(name, pos, decls)
    }

    func blockDecls() -> BlockDecl {
        let pos = tok.pos
        check(.lcbr)
        var decls: [Decl] = []
        if tok.kind != .rcbr {
            var c = 0
            while (true) {
                let decl = self.decl()
                decls.append(decl)
                if [.eof, .rcbr].contains(tok.kind) {
                    break
                }
                c += 1
                if c > 1_000_000 {
                    fatalError("invalid decls")
                }
            }
        }
        check(.rcbr)
        return BlockDecl(decls, pos)
    }

    func interfaceDecl() -> Decl {
        let pos = tok.pos
        check(.key_interface)
        let name = nameExpr()
        let decls = blockDecls()
        return InterfaceDecl(name, pos, decls)
    }

    func implDecl() -> Decl {
        let pos = tok.pos
        check(.key_impl)
        let name = nameExpr()
        let decls = blockDecls()
        return ImplDecl(name, pos, decls)
    }
}
