
typealias SIndex = String.UnicodeScalarView.Index
typealias SString = String

class Position: Object {
    var filename: String
    var offset: SIndex
    var len: Int
    var line: Int
    var endLine: Int
    var column: Int
    var endColumn: Int

    override init() {
        self.filename = ""
        self.offset = "".startIndex
        self.len = 0
        self.line = 0
        self.endLine = 0
        self.column = 0
        self.endColumn = 0
    }

    init(_ filename: String, _ offset: SIndex, _ len: Int, _ line: Int, _ column: Int) {
        self.filename = filename
        self.offset = offset
        self.len = len
        self.line = line
        self.endLine = line
        self.column = column
        self.endColumn = column
    }

    init(_ pos: Position) {
        self.filename = pos.filename
        self.offset = pos.offset
        self.len = pos.len
        self.line = pos.line
        self.endLine = pos.endLine
        self.column = pos.column
        self.endColumn = pos.endColumn
    }

    func getPositionText(text: String) -> String {
        return String(text[offset...text.index(offset, offsetBy: len)])
    }

    // end must be next to the current position, and is after it
    // they must be the same line
    func addPosition(_ end: Position) {
        // same line
        self.len += end.len
        self.endLine = end.endLine
        self.endColumn = end.endColumn
    }

    func contains(_ pos: Position) -> Bool {
        if self.line > pos.line || self.endLine < pos.endLine {
            return false
        }
        if self.line == pos.line && self.endLine == pos.endLine {
            if self.column > pos.column || self.column <= pos.column && self.len < pos.len {
                return false
            }
        }
        return true
    }

    func isLeft(_ pos: Position) -> Bool {
        if self.line > pos.endLine {
            return true
        }
        if self.line == pos.endLine && self.column >= pos.endColumn {
            return true
        }
        return false
    }

    func clone() -> Position {
        return Position(self)
    }
}