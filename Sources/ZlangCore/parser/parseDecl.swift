
extension Parser {

    func nameDecl(_ annotationRequired: Bool = false) -> NameDecl {
        let pos = tok.pos
        let name = checkName()
        var annotation: Expr? = nil
        if annotationRequired || tok.kind == .colon {
            check(.colon)
            annotation = expr()
        }
        var defaultValue: Expr? = nil
        if tok.kind == .assign {
            check(.assign)
            defaultValue = expr()
        }
        if let a = annotation {
            if let d = defaultValue {
                return NameDecl(name, pos, a, d)
            }
            return NameDecl(name, pos, a)
        }
        if let d = defaultValue {
            return NameDecl(name, pos, defaultValue: d)
        }
        return NameDecl(name, pos)
    }

    func names(_ annotationRequired: Bool = false) -> [NameDecl] {
        var names: [NameDecl] = []
        while (true) {
            if tok.kind == .rpar || tok.kind == .eof {
                break
            }
            if tok.kind == .key_var {
                names.append(varOrConstDecl(true) as! NameDecl)
            } else {
                names.append(nameDecl(annotationRequired))
            }
            if tok.kind != .comma {
                break
            }
            next()
        }
        return names
    }

    func args(_ annotationRequired: Bool = false) -> Names {
        let pos = tok.pos
        check(.lpar)
        let left = self.names(annotationRequired)
        pos.addPosition(tok.pos)
        check(.rpar)
        return Names(left, pos, annotationRequired)
    }

    func varOrConstDecl(_ mustSingleDecl: Bool = false) -> Decl {
        var isVar: Bool = false
        if tok.kind == .key_var {
            check(.key_var)
            isVar = true
        } else {
            check(.key_const)
        }
        let pos = tok.pos
        if !mustSingleDecl && tok.kind == .lpar {
            let left = args()
            if tok.kind == .assign {
                check(.assign)
                let right = tupleExpr()
                pos.addPosition(right.pos)
                return TupleDecl(left, pos, right, isVar)
            }
            return TupleDecl(left, pos, isVar)
        }
        let name = nameDecl()
        name.isVar = isVar
        return name
    }

    // func varDecl() -> Decl {
    //     return varOrConstDecl(true)
    // }

    // func constDecl() -> Decl {
    //     return varOrConstDecl()
    // }

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
        check(.key_type)
        let pos = tok.pos
        let name = checkName()
        let isAlias = tok.kind == .assign
        if isAlias {
            next()
        }
        let type = expr()
        return TypeDecl(name, pos, type, isAlias)
    } 

    func commentStmt() -> Comment {
        return Comment()
    }

    func fnDecl() -> Decl {
        let pos = tok.pos
        check(.key_func)
        let name = checkName()
        let args = self.args(true)
        var returns: Names
        if tok.kind == .lpar {
            returns = self.args(true)
            pos.addPosition(returns.pos)
        } else {
            returns = Names([], pos)
        }
        var blockStmt: BlockStmt?
        if tok.kind == .lcbr {
            blockStmt = self.blockStmt()
        }
        if let b = blockStmt {
            pos.addPosition(b.pos)
            return FnDecl(name, pos, args, returns, b)
        }
        return FnDecl(name, pos, args, returns)
    }

    func structDecl() -> StructDecl {
        let pos = tok.pos
        check(.key_struct)
        let name = checkName()
        let decls = blockDecls()
        return StructDecl(name, pos, decls)
    }

    func enumDecl() -> Decl {
        let pos = tok.pos
        check(.key_enum)
        let name = checkName()
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
        next()
        return BlockDecl(decls, pos)
    }

    func interfaceDecl() -> Decl {
        let pos = tok.pos
        check(.key_interface)
        let name = checkName()
        let decls = blockDecls()
        return InterfaceDecl(name, pos, decls)
    }

    func implDecl() -> Decl {
        let pos = tok.pos
        check(.key_impl)
        let name = checkName()
        let decls = blockDecls()
        return ImplDecl(name, pos, decls)
    }
}