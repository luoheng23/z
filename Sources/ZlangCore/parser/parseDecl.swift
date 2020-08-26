
extension Parser {
    func varDecl() -> Decl {
        check(.key_var)
        let left = expr()
        if tok.kind == .assign {
            check(.assign)
            let right = expr()
            if left is TupleExpr && right is TupleExpr {
                return TupleDecl(left as! TupleExpr, right as! TupleExpr, true)
            }
            return NameDecl(left, right, true)
        } else {
            if left is TupleExpr {
                return TupleDecl(left as! TupleExpr, true)
            }
            return NameDecl(left, true)
        }
    }

    func constDecl() -> Decl {
        check(.key_const)
        let left = expr()
        if tok.kind == .assign {
            check(.assign)
            let right = expr()
            if left is TupleExpr && right is TupleExpr {
                return TupleDecl(left as! TupleExpr, right as! TupleExpr)
            }
            return NameDecl(left, right)
        } else {
            if left is TupleExpr {
                return TupleDecl(left as! TupleExpr, TupleExpr())
            }
            return NameDecl(left, Expr())
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

    func fnDecl() -> Stmt {
        let pos = tok.pos
        check(.key_func)
        let name = checkName()
        let args = expr() as! TupleExpr
        var blockStmt: BlockStmt?
        if tok.kind == .lcbr {
            blockStmt = BlockStmt()
        }
        if blockStmt == nil {
            return FnDecl(name, args, returns)
        }
        return FnDecl(name, args, returns, blockStmt)
    }

    func structDecl() -> StructDecl {
        let pos = tok.pos
        check(.key_struct)
        let name = checkName()
        let decls = blockDecls()
        return StructDecl(name, pos, decls)
    }

    func enumDecl() -> Stmt {
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
                let decl = stmt()
                if decl is Decl {
                    decls.append(decl as! Decl)
                } else {
                    fatalError("invalid decl \(decl.text())")
                }
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

    func interfaceDecl() -> Stmt {
        let pos = tok.pos
        check(.key_interface)
        let name = checkName()
        let decls = blockDecls()
        return InterfaceDecl(name, pos, decls)
    }

    func implDecl() -> Stmt {
        let pos = tok.pos
        check(.key_impl)
        let name = checkName()
        let decls = blockDecls()
        return ImplDecl(name, pos, decls)
    }
}