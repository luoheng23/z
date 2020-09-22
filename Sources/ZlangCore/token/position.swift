
typealias SIndex = String.UnicodeScalarView.Index
typealias SString = String

class Position {
    var filename: String
    var offset: SIndex
    var line: Int
    var column: Int

    init() {
        self.filename = ""
        self.offset = "".startIndex
        self.line = 0
        self.column = 0
    }

    init(filename: Int, offset: Int, line: Int, column: SIndex) {
        self.filename = filename
        self.offset = offset
        self.line = line
        self.column = column
    }

    convenience init(pos: Position) {
        self.init(pos.filename, pos.offset, pos.line, pos.column)
    }

    func str() -> String {
        
    }

    func getPositionText(text: String) -> String {
        return String(text[text.index(lineBegin, after: startPos)...text.index(lineBegin, after: endPos)])
    }

    func addPosition(_ end: Position) {
        count = end.pos - self.pos + end.count
    }

    func contains(_ pos: Int) -> Bool {
        return startPos <= pos && pos <= endPos
    }
}