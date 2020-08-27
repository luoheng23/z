class TupleDecl: Decl {
    var left: Names
    var right: TupleExpr?
    var isVar: Bool
    var word: String { isVar ? "var" : "const" }

    init(_ left: Names, _ pos: Position, _ isVar: Bool = false) {
        self.left = left
        self.isVar = isVar
        self.right = nil
        super.init(pos)
    }

    init(_ left: Names, _ pos: Position, _ right: TupleExpr, _ isVar: Bool = false) {
        self.left = left
        self.right = right
        self.isVar = isVar
        super.init(pos)
    }

    override func str() -> String {
        var str = "TupleDecl(\(word) \(left.str())"
        if let r = right {
            str += " = \(r.str())"
        }
        str += ")"
        return str
    }

    override func text() -> String {
        var str = "\(word) \(left.text())"
        if let r = right {
            str += " = \(r.text())"
        }
        return str
    }
}

class NameDecl: Decl {
    var name: String
    var typeAnnotation: Expr?
    var defaultValue: Expr?
    var isVar: Bool = false
    var word: String { isVar ? "var" : "const" }

    init(_ name: String, _ pos: Position) {
        self.name = name
        self.typeAnnotation = nil
        self.defaultValue = nil
        super.init(pos)
    }

    init(_ name: String, _ pos: Position, _ typeAnnotation: Expr) {
        self.name = name
        self.typeAnnotation = typeAnnotation
        super.init(pos)
    }

    init(_ name: String, _ pos: Position, defaultValue: Expr) {
        self.name = name
        self.defaultValue = defaultValue
        self.typeAnnotation = nil
        super.init(pos)
    }

    init(_ name: String, _ pos: Position, _ typeAnnotation: Expr, _ defaultValue: Expr) {
        self.name = name
        self.typeAnnotation = typeAnnotation
        self.defaultValue = defaultValue
        super.init(pos)
    }

    override func str() -> String {
        return str(true)
    }

    func str(_ outputWord: Bool = true) -> String {
        var str = "Name("
        str += outputWord ? "\(word) \(name)" : name
        if let t = typeAnnotation {
            str += ": \(t.str())"
        }
        if let t = defaultValue {
            str += " = \(t.str())"
        }
        str += ")"
        return str
    }

    override func text() -> String {
        return text(true)
    }

    func text(_ outputWord: Bool = true) -> String {
        var str = outputWord ? "\(word) \(name)" : name
        if let t = typeAnnotation {
            str += ": \(t.text())"
        }
        if let t = defaultValue {
            str += " = \(t.text())"
        }
        return str
    }
}

class Names: Decl {
    var names: [NameDecl]
    var count: Int { names.count }
    var isArg: Bool

    override init() {
        self.names = []
        self.isArg = false
        super.init()
    }

    init(_ names: [NameDecl], _ pos: Position, _ isArg: Bool = false) {
        self.names = names
        self.isArg = isArg
        super.init(pos)
    }

    override func str() -> String {
        var str = "Names(("
        str += names.map { name in
            if isArg && name.isVar {
                return name.str(isArg)
            }
            return name.str(false)
        }.joined(separator: ", ")
        str += "))"
        return str
    }

    override func text() -> String {
        var str = "("
        str += names.map { name in
            if isArg && name.isVar {
                return name.text(isArg)
            }
            return name.text(false)
        }.joined(separator: ", ")
        str += ")"
        return str
    }
}

class TypeDecl: Decl {
    var name: String
    var referenceType: Expr
    var isAlias: Bool
    var word: String { isAlias ? " =" : ""}
    init(_ name: String, _ pos: Position, _ expr: Expr, _ isAlias: Bool = false) {
        self.name = name
        self.referenceType = expr
        self.isAlias = isAlias
        let p = pos
        p.addPosition(expr.pos)
        super.init(p)
    }

    override func str() -> String {
        return "TypeDecl(type \(name)\(word) \(referenceType.str()))"
    }

    override func text() -> String {
        return "type \(name)\(word) \(referenceType.text())"
    }
}

class BlockDecl: Decl {
    var decls: [Decl]

    init(_ decls: [Decl], _ pos: Position) {
        self.decls = decls
        super.init(pos)
    }

    override func str() -> String {
        var str = "BlockDecl({"
        if decls.count != 0 {
            str += "\n"
        }
        str += decls.map { decl in
            "    " + decl.str()
        }.joined(separator: "\n")
        if decls.count != 0 {
            str += "\n"
        }
        str += "})"
        return str
    }

    override func text() -> String {
        var str = "{"
        if decls.count != 0 {
            str += "\n"
        }
        str += decls.map { decl in
            "    " + decl.text()
        }.joined(separator: "\n")
        if decls.count != 0 {
            str += "\n"
        }
        str += "}"
        return str
    }
}

class StructDecl: Decl {
    var name: String
    var decls: BlockDecl

    init(_ name: String, _ pos: Position, _ decls: BlockDecl) {
        self.decls = decls
        self.name = name
        super.init(pos)
    }

    override func str() -> String {
        return "StructDecl(struct \(name) \(decls.str()))"
    }

    override func text() -> String {
        return "struct \(name) \(decls.text())"
    }
}

class EnumDecl: Decl {
    var name: String
    var decls: BlockDecl

    init(_ name: String, _ pos: Position, _ decls: BlockDecl) {
        self.decls = decls
        self.name = name
        super.init(pos)
    }

    override func str() -> String {
        return "EnumDecl(enum \(name) \(decls.str()))"
    }

    override func text() -> String {
        return "enum \(name) \(decls.text())"
    }
}

class InterfaceDecl: Decl {
    var name: String
    var decls: BlockDecl

    init(_ name: String, _ pos: Position, _ decls: BlockDecl) {
        self.decls = decls
        self.name = name
        super.init(pos)
    }

    override func str() -> String {
        return "InterfaceDecl(interface \(name) \(decls.str()))"
    }

    override func text() -> String {
        return "interface \(name) \(decls.text())"
    }
}

class ImplDecl: Decl {
    var name: String
    var decls: BlockDecl

    init(_ name: String, _ pos: Position, _ decls: BlockDecl) {
        self.decls = decls
        self.name = name
        super.init(pos)
    }

    override func str() -> String {
        return "ImplDecl(impl \(name) \(decls.str()))"
    }

    override func text() -> String {
        return "impl \(name) \(decls.text())"
    }
}

// class ArgDecl: Decl {
//     var nameDecls: Names

//     override init() {
//         self.nameDecls = Names()
//         super.init()
//     }

//     init(_ nameDecls: Names, _ pos: Position) {
//         self.nameDecls = nameDecls
//         super.init(pos)
//     }

//     override func str() -> String {
//         var str = "ArgDecl(("
//         str += nameDecls.names.map { name in
//             if name.isVar {
//                 return name.str()
//             }
//             return name.str(false)
//         }.joined(separator: ", ")
//         str += "))"
//         return str
//     }

//     override func text() -> String {
//         var str = "("
//         str += nameDecls.names.map { name in
//             print(name, name.isVar)
//             if name.isVar {
//                 return name.str()
//             }
//             return name.str(false)
//         }.joined(separator: ", ")
//         str += ")"
//         return str
//     }
// }

class FnDecl: Decl {
    var name: String
    var args: Names
    var returns: Names
    var blockStmt: BlockStmt?

    init(_ name: String, _ pos: Position, _ args: Names, _ returns: Names) {
        self.name = name
        self.args = args
        self.returns = returns
        self.blockStmt = nil
        super.init(pos)
    }

    convenience init(_ name: String, _ pos: Position, _ args: Names, _ returns: Names, _ blockStmt: BlockStmt) {
        self.init(name, pos, args, returns)
        self.blockStmt = blockStmt
    }

    override func str() -> String {
        var str = "fn \(name)"
        str += "\(args.str()) \(returns.str())"
        if let stmt = blockStmt {
            str += stmt.str()
        }
        return str
    }

    override func text() -> String {
        var str = "fn \(name)"
        str += "\(args.text())"
        if returns.count != 0 {
            str += " \(returns.text())"
        }
        if let stmt = blockStmt {
            str += " \(stmt.text())"
        }
        return str
    }
}