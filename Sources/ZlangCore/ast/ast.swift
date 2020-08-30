
class Ast { 
    var pos: Position
    var typeInfo: Value?

    var node: String { String(describing: type(of: self)) }

    init() {
        self.pos = Position()
        self.typeInfo = nil
    }

    init(_ pos: Position) {
        self.pos = pos
        self.typeInfo = nil
    }

    init(_ pos: Position, _ typeInfo: Value) {
        self.pos = pos
        self.typeInfo = typeInfo
    }

    init(_ other: Ast) {
        self.pos = other.pos
        self.typeInfo = other.typeInfo
    }

    func setType(_ typeInfo: Value) {
        self.typeInfo = typeInfo
    }

    func hasType() -> Bool {
        return self.typeInfo != nil
    }

    func str() -> String {
        return "\(node)()"
    }

    func text() -> String {
        return ""
    }

    func gen() -> String {
        return text()
    }
}

class Decl: Stmt {}

class Stmt: Ast {}

class Expr: Ast {}