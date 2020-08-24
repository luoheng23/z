
typealias SIndex = String.UnicodeScalarView.Index
typealias SString = String

class Position {
    var lineBegin: SIndex
    var lineNr: Int
    var pos: Int
    var count: Int = 0

    var startPos: Int { return pos }
    var endPos: Int { return pos + count }

    init() {
        self.lineBegin = "".startIndex
        self.lineNr = 0
        self.pos = 0
        self.count = 0
    }

    init(count: Int, lineNr: Int, pos: Int, lineBegin: SIndex) {
        self.lineNr = lineNr
        self.count = count
        self.lineBegin = lineBegin
        self.pos = pos
    }

    func str() -> String {
        return "Position(lineNr: \(lineNr), pos: \(pos), length: \(count)"
    }

    func addPosition(_ end: Position) {
        count = end.pos - self.pos + end.count
    }
}