
class Ast { 
    var pos: Position 
    var comments: [Comment]
    var type: TypeSymbol?

    init() {
        self.pos = Position()
        self.comments = []
        self.type = nil
    }

    init(_ pos: Position, _ comments: [Comment], _ type: TypeSymbol) {
        self.pos = pos
        self.comments = comments
        self.type = type
    }

    init(_ pos: Position, _ comments: [Comment]) {
        self.pos = pos
        self.comments = comments
        self.type = nil
    }

    init(_ other: Ast) {
        self.pos = other.pos
        self.comments = other.comments
        self.type = other.type
    }

    func addComment(_ comment: Comment) {
        comments.append(comment)
    }

    func addComments(_ comments: [Comment]) {
        self.comments += comments
    }

    func str() -> String {
        return "Ast()"
    }

    func text() -> String {
        return ""
    }
}

class Decl: Ast {}

class Stmt: Ast {}

class Expr: Ast {}

class ConstField {}