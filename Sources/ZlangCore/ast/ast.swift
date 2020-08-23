
class Ast { 
    var pos: Position 
    var comments: [Comment]
    var type: Type?

    init() {
        self.pos = Position()
        self.comments = []
        self.type = ._nil
    }
    init(_ pos: Position, _ comments: [Comment], _ type: Type) {
        self.pos = pos
        self.comments = comments
        self.type = type
    }
}

class Decl: Ast {}

class Stmt: Ast {}

class Expr: Ast {}

class ConstField {}