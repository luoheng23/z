

public class Position {
    public var count: Int
    public var lineNr: Int
    public var pos: Int

    public init(count: Int, lineNr: Int, pos: Int) {
         self.count = count
         self.lineNr = lineNr
         self.pos = pos
    }

    public func string() -> String {
        return "Position(lineNr: \(lineNr), pos: \(pos), length: \(count)"
    }

    public func addPosition(_ end: Position) {
        count = end.pos - self.pos + end.count
    }
}