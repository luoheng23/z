
typealias SIndex = String.UnicodeScalarView.Index
typealias SString = String

class Position {
    var lineBegin: SIndex
    var lineNr: Int
    var pos: Int
    var length: Int = 0

    init() {
        self.lineBegin = "".startIndex
        self.lineNr = 0
        self.pos = 0
        self.length = 0
    }

    init(length: Int, lineNr: Int, pos: Int, lineBegin: SIndex) {
        self.lineNr = lineNr
        self.length = length
        self.lineBegin = lineBegin
        self.pos = pos
    }

    func string() -> String {
        return "Position(lineNr: \(lineNr), pos: \(pos), length: \(length)"
    }

    func addPosition(_ end: Position) {
        length = end.pos - self.pos + end.length
    }
}