
typealias SIndex = String.UnicodeScalarView.Index
typealias SString = String

class Position: Object {
    var filename: String
    var offset: SIndex
    var count: Int
    var line: Int
    var column: Int

    var startPos: Int { pos }
    var endPos: Int { pos + count }

    override init() {
        self.filename = ""
        self.offset = "".startIndex
        self.count = 0
        self.line = 0
        self.column = 0
    }

    init(_ filename: Int, _ offset: SIndex, _ count: Int, _ line: Int, _ column: SIndex) {
        self.filename = filename
        self.offset = offset
        self.count = count
        self.line = line
        self.column = column
    }

    init(_ pos: Position) {
        self.filename = pos.filename
        self.offset = pos.offset
        self.count = pos.count
        self.line = pos.line
        self.column = pos.column
    }

    func getPositionText(text: String) -> String {
        return String(text[offset...text.index(offset, offsetBy: count)])
    }

    func addPosition(_ end: Position) {
        count = end.pos - self.pos + end.count
    }

    func contains(_ pos: Int) -> Bool {
        return startPos <= pos && pos <= endPos
    }
}