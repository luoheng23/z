
class Ast { 
    var pos: Position
    var type: Value?

    var node: String { String(describing: type(of: self)) }

    init() {
        self.pos = Position()
        self.type = nil
    }

    init(_ pos: Position) {
        self.pos = pos
        self.type = nil
    }

    init(_ pos: Position, _ type: Value) {
        self.pos = pos
        self.type = type
    }

    init(_ other: Ast) {
        self.pos = other.pos
        self.type = other.type
    }

    func setType(_ type: Value) {
        self.type = type
    }

    func hasType() -> Bool {
        return self.type != nil
    }

    func str() -> String {
        return "\(node)()"
    }

    func text() -> String {
        return ""
    }
}

class Decl: Stmt {}

class Stmt: Ast {}

class Expr: Ast {}