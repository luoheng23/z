
extension Parser {

    func basicNameDecl(_ annotationRequired: Bool = false) -> OneNameAnnotationDecl {
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
        } else {
            check(.key_const)
        }
        let basicName = basicNameDecl(false)
        basicName.isVar = isVar
        pos.addPosition(basicName.pos)
        return NameDecl(basicName, pos)
    }

    func argDecl() -> ArgDecl {
        let pos = tok.pos
        let isVar = isTok(.key_var)
        if isVar {
            check(.key_var)
        }
        let basicName = basicNameDecl(true)
        basicName.isVar = isVar
        pos.addPosition(basicName.pos)
        return ArgDecl(basicName, pos)
    }

    func tupleArgDecl() -> TupleArgDecl {
        let pos = tok.pos
        check(.lpar)
        let args = basicTupleExpr(argDecl)
        pos.addPosition(tok.pos)
        check(.rpar)
        return TupleArgDecl(args, pos)
    }

    func tupleNameDecl() -> TupleNameDecl {
        let pos = tok.pos
        let isVar = isTok(.key_var)
        if isVar {
            check(.key_var)
        } else {
            check(.key_const)
        }
        check(.lpar)
        let left = basicTupleExpr(nameDecl)
        var right: TupleExpr? = nil
        if isTok(.assign) {
            right = tupleExpr()
        }
        pos.addPosition(tok.pos)
        check(.rpar)
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

    func decl() -> Decl {
        switch (tok.kind) {
        case .key_var, .key_const:
            return varOrConstDecl()
        case .key_type:
            return typeDecl()
        case .key_enum:
            return enumDecl()
        case .key_struct:
            return structDecl()
        case .key_interface:
            return interfaceDecl()
        case .key_impl:
            return implDecl()
        case .key_func:
            return fnDecl()
        default:
            fatalError("invalid decl: \(tok.kind)")
        }

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
        pos.addPosition(type.pos)
        return TypeDecl(name, pos, type, isAlias)
    } 

    func fnDecl() -> Decl {
        let pos = tok.pos
        check(.key_func)
        let name = nameExpr()
        let args = tupleArgDecl()
        var returns: TupleArgDecl?
        if isTok(.lpar) {
            returns = tupleArgDecl()
            pos.addPosition(returns!.pos)
        }
        var blockStmt: BlockStmt?
        if isTok(.lcbr) {
            blockStmt = self.blockStmt()
        }
        if let b = blockStmt {
            pos.addPosition(b.pos)
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
                if c > 1000000 {
                    fatalError("invalid decls")
                }
            }
        }
        pos.addPosition(tok.pos)
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