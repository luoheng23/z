class OneNameAnnotationDecl: Decl {
    var name: NameExpr
    var typeAnnotation: Expr?
    var defaultValue: Expr?
    var isVar: Bool
    var word: String = ""

    init(_ name: NameExpr, _ pos: Position, _ isVar: Bool) {
        self.name = name
        self.typeAnnotation = nil
        self.defaultValue = nil
        self.isVar = isVar
        super.init(pos)
    }

    init(_ name: NameExpr, _ pos: Position, _ typeAnnotation: Expr, _ isVar: Bool) {
        self.name = name
        self.typeAnnotation = typeAnnotation
        self.isVar = isVar
        self.defaultValue = nil
        super.init(pos)
    }

    init(_ name: NameExpr, _ pos: Position, defaultValue: Expr, _ isVar: Bool) {
        self.name = name
        self.defaultValue = defaultValue
        self.isVar = isVar
        self.typeAnnotation = nil
        super.init(pos)
    }

    init(_ name: NameExpr, _ pos: Position, _ typeAnnotation: Expr, _ defaultValue: Expr, _ isVar: Bool) {
        self.name = name
        self.typeAnnotation = typeAnnotation
        self.defaultValue = defaultValue
        self.isVar = isVar
        super.init(pos)
    }

    override func str() -> String {
        var str = "\(node)(\(word)\(name)"
        if let t = typeAnnotation {
            str += " \(t.str())"
        }
        if let t = defaultValue {
            str += " = \(t.str())"
        }
        str += ")"
        return str
    }

    override func text() -> String {
        var str = "\(word)\(name)"
        if let t = typeAnnotation {
            str += " \(t.text())"
        }
        if let t = defaultValue {
            str += " = \(t.text())"
        }
        return str
    }
}

class NameDecl: OneNameAnnotationDecl {
    override var word: String { isVar ? "var " : "const " }
}

class ArgDecl: OneNameAnnotationDecl {
    override var word: String { isVar ? "var " : "" }
}

class TupleArgDecl: Decl {
    var args: [ArgDecl]

    init(_ args: [ArgDecl], _ pos: Position) {
        self.args = args
        super.init(pos)
    }

    init(_ args: [ArgDecl], _ pos: Position) {
        self.args = args
        super.init(pos)
    }

    override func str() -> String {
        var str = args.map { arg in arg.str() }.joined(separator: ", ")
        return "\(node)((\(str)))"
    }

    override func text() -> String {
        var str = args.map { arg in arg.text() }.joined(separator: ", ")
        return "(\(str))"
    }

}

class TupleNameDecl: Decl {
    var left: [OneNameAnnotationDecl]
    var right: TupleExpr?
    var isVar: Bool
    var word: String { isVar ? "var" : "const" }

    init(_ left: [OneNameAnnotationDecl], _ pos: Position, _ isVar: Bool = false) {
        self.left = left
        self.isVar = isVar
        self.right = nil
        super.init(pos)
    }

    init(_ left: [OneNameAnnotationDecl], _ pos: Position, _ right: TupleExpr, _ isVar: Bool = false) {
        self.left = left
        self.right = right
        self.isVar = isVar
        super.init(pos)
    }

    override func str() -> String {
        var str = left.map { arg in arg.text() }.joined(separator: ", ")
        str = "\(node)(\(word) \(str)"
        if let r = right {
            str += " = \(r.str())"
        }
        str += ")"
        return str
    }

    override func text() -> String {
        var str = left.map { arg in arg.text() }.joined(separator: ", ")
        str = "\(word) \(str)"
        if let r = right {
            str += " = \(r.text())"
        }
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
        return "\(node)(type \(name)\(word) \(referenceType.str()))"
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
        var str = "\(node)({"
        if decls.count != 0 {
            str += "\n"
        }
        str += decls.map { decl in "    " + decl.str() }.joined(separator: "\n")
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
        str += decls.map { decl in "    " + decl.text() }.joined(separator: "\n")
        if decls.count != 0 {
            str += "\n"
        }
        str += "}"
        return str
    }
}

class CombinationDecl: Decl {
    var name: String
    var typeName: String = ""
    var decls: BlockDecl

    init(_ name: String, _ pos: Position, _ decls: BlockDecl) {
        self.decls = decls
        self.name = name
        super.init(pos)
    }

    override func str() -> String {
        return "\(node)(\(typeName) \(name) \(decls.str()))"
    }

    override func text() -> String {
        return "\(typeName) \(name) \(decls.text())"
    }

}

class StructDecl: CombinationDecl {
    override var typeName: String = "struct"
}

class EnumDecl: CombinationDecl {
    override var typeName: String = "enum"
}

class InterfaceDecl: CombinationDecl {
    override var typeName: String = "interface"
}

class ImplDecl: CombinationDecl {
    override var typeName: String = "impl"
}

class FnDecl: Decl {
    var name: String
    var args: TupleArgDecl
    var returns: TupleArgDecl?
    var blockStmt: BlockStmt?

    init(_ name: String, _ pos: Position, _ args: TupleArgDecl) {
        self.name = name
        self.pos = pos
        self.args = args
        
    }
    init(_ name: String, _ pos: Position, _ args: TupleArgDecl, _ returns: TupleArgDecl) {
        self.name = name
        self.args = args
        self.returns = returns
        self.blockStmt = nil
        super.init(pos)
    }

    convenience init(_ name: String, _ pos: Position, _ args: TupleArgDecl, _ returns: TupleArgDecl, _ blockStmt: BlockStmt) {
        self.init(name, pos, args, returns)
        self.blockStmt = blockStmt
    }

    override func str() -> String {
        var str = "fn \(name)"
        str += "\(args.str())"
        if let r = returns {
            str += " \(r.str())"
        }
        if let stmt = blockStmt {
            str += stmt.str()
        }
        str = "\(node)(\(str))"
        return str
    }

    override func text() -> String {
        var str = "fn \(name)"
        str += "\(args.text())"
        if let r = returns {
            str += " \(r.str())"
        }
        if let stmt = blockStmt {
            str += " \(stmt.text())"
        }
        return str
    }
}