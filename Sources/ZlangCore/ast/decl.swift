class TupleDecl: Decl {
    var left: TupleExpr
    var right: TupleExpr?
    var isVar: Bool
    var word: String { isVar ? "var" : "const" }

    init(_ left: TupleExpr, _ isVar: Bool = false) {
        self.left = left
        self.isVar = isVar
        self.right = nil
    }

    init(_ left: TupleExpr, _ right: TupleExpr, _ isVar: Bool = false) {
        self.left = left
        self.right = right
        self.isVar = isVar
        let pos = left.pos
        pos.addPosition(right.pos)
        super.init(pos)
    }

    override func str() -> String {
        return "TupleDecl(\(word) \(left.str()) = \(right.str()))"
    }

    override func text() -> String {
        return "\(word) \(left.text()) = \(right.text())"
    }
}

class NameDecl: Decl {
    var left: Expr
    var right: Expr
    var isVar: Bool
    var word: String { isVar ? "var" : "const"}

    init(_ left: Expr, _ right: Expr, _ isVar: Bool = false) {
        self.left = left
        self.right = right
        self.isVar = isVar
        let pos = left.pos
        pos.addPosition(right.pos)
        super.init(pos)
    }
    override func str() -> String {
        return "NameDecl(\(word) \(left.str()) = \(right.str()))"
    }

    override func text() -> String {
        return "\(word) \(left.text()) = \(right.text())"
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
        return decls.map { decl in
            return decl.str()
        }.joined(separator: "\n")
    }

    override func text() -> String {
        return decls.map { decl in
            return decl.text()
        }.joined(separator: "\n")
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
        var str = "StructDecl(struct \(name) {\n"
        str += decls.str().split(separator: "\n").map { d in
            return "    " + d
        }.joined(separator: "\n")
        str += "\n})"
        return str
    }

    override func text() -> String {
        var str = "struct \(name) {\n"
        str += decls.text().split(separator: "\n").map { d in
            return "    " + d
        }.joined(separator: "\n")
        str += "\n}"
        return str
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
        var str = "EnumDecl(enum \(name) {\n"
        str += decls.str().split(separator: "\n").map { d in
            return "    " + d
        }.joined(separator: "\n")
        str += "\n})"
        return str
    }

    override func text() -> String {
        var str = "enum \(name) {\n"
        str += decls.text().split(separator: "\n").map { d in
            return "    " + d
        }.joined(separator: "\n")
        str += "\n}"
        return str
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
        var str = "InterfaceDecl(interface \(name) {\n"
        str += decls.str().split(separator: "\n").map { d in
            return "    " + d
        }.joined(separator: "\n")
        str += "\n})"
        return str
    }

    override func text() -> String {
        var str = "interface \(name) {\n"
        str += decls.text().split(separator: "\n").map { d in
            return "    " + d
        }.joined(separator: "\n")
        str += "\n}"
        return str
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
        var str = "ImplDecl(impl \(name) {\n"
        str += decls.str().split(separator: "\n").map { d in
            return "    " + d
        }.joined(separator: "\n")
        str += "\n})"
        return str
    }

    override func text() -> String {
        var str = "impl \(name) {\n"
        str += decls.text().split(separator: "\n").map { d in
            return "    " + d
        }.joined(separator: "\n")
        str += "\n}"
        return str
    }
}


class FnDecl: Decl {
    var name: String
    var args: TupleDecl
    var returns: TupleDecl
    var blockStmt: BlockStmt?

    init(_ name: String, _ pos: Position, _ args: TupleDecl, _ returns: TupleDecl) {
        self.name = name
        self.args = args
        self.returns = returns
        self.blockStmt = nil
        super.init(pos)
    }

    convenience init(_ name: String, _ pos: Position, _ args: TupleDecl, _ returns: TupleDecl, _ blockStmt: BlockStmt) {
        self.init(name, pos, args, returns)
        self.blockStmt = blockStmt
    }

    override func str() -> String {
        var str = "func \(name)"
        str += "\(args.str()) \(returns.str())"
        if let stmt = blockStmt {
            str += stmt.str()
        }
        return str
    }

    override func text() -> String {
        var str = "func \(name)"
        str += "\(args.text()) \(returns.text())"
        if let stmt = blockStmt {
            str += stmt.text()
        }
        return str
    }
}