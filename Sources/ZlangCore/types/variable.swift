
// information for all types and values, stmt and so on
class BasicInfo {
    var pos: Position 
    var comment: [Comment] = []

    init(_ pos: Position, _ comment: [Comment]) {
        self.pos = pos
        self.comment = comment
    }
}