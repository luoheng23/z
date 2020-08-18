
import Files

struct ScanRes {
    let tok: Token
    let lit: String
    init(tok: Token, lit: String) {
        self.tok = tok
        self.lit = lit
    }

}

class Scanner {

    public typealias SIndex = String.UnicodeScalarView.Index
    public typealias SString = String

    public var text: SString
    public var pos: SIndex

    public var startIndex: SIndex {
        return self.text.startIndex
    }

    public var endIndex: SIndex {
        return self.text.endIndex
    }

    public var isAtEnd: Bool {
        return self.pos == self.endIndex
    }


    var filePath: String = ""
    var newlineNum: Int = 0
    let count: Int
    var lastNewLinePos: SIndex
    var insideString: Bool = false
    var interStart: Bool = false
    var interEnd: Bool = false
    var debug: Bool = false
    var lineComment: String = ""
    var started: Bool = false

    var fileLines: [String] = []
    var prevTok: Token?
    var fnName: String = ""


    convenience init(filePath: String) {
        if let file = try? (try? File(path: filePath))?.read() {
            self.init(String(decoding: file, as: UTF8.self))
            self.filePath = filePath
        } else {
            self.init("")
            error("\(filePath) doesn't exist")
        }
    }

    init(_ string: String) {
        self.pos = string.startIndex
        self.lastNewLinePos = string.startIndex
        self.text = string
        self.count = string.count
    }

    func nextChar() -> Character? {
        nextPos()
        return peek()
    }

    func nextPos() {
        pos = text.index(after: pos)
    }

    func peek() -> Character? {
        if isAtEnd {
            return nil
        }
        return text[pos]
    }

    func nextPeek() -> Character? {
        let p = text.index(after: pos)
        if p == text.endIndex {
            return nil
        }
        return text[p]
    }

    public func index(pos: SIndex, after: Int) -> SIndex {
        if let res = text.index(pos, offsetBy: after, limitedBy: endIndex) {
            return res
        }
        return endIndex
    }

    public func _getStr(_ start: SIndex, _ end: SIndex) -> String {
        return String(text[start..<end])
    }

    public func getStr(_ start: SIndex) -> String {
        return _getStr(start, pos)
    }

    func name() -> String? {
        if isAtEnd {
            return nil
        }
        let start = pos
        while let char = nextChar(), char.isLetter() {}
        return getStr(start)
    }

    func skipWhitespace(){
        while let c = peek(), c.isWhitespace() {
            if c.isNewLine() && !expect(want: "\r\n", startPos: index(pos: pos, after: -1)) {
                incLineNum()
            }
            nextPos()
        }
    }

    func incLineNum() {
        lastNewLinePos = pos
        newlineNum += 1
    }

    func hexNum() -> String {
        return _num(prefixStr: Character.prefixHex, exponent: Character.hexExp)
    }

    func octNum() -> String {
        return _num(prefixStr: Character.prefixOct, exponent: Character.octExp)
    }

    func decNum() -> String {
        return _num(prefixStr: Character.prefixDec, exponent: Character.decExp)
    }

    func binNum() -> String {
        return _num(prefixStr: Character.prefixBin, exponent: Character.binExp)
    }

    func _numIntegerPart(prefixStr: String) {
        var isUnderScore = false
        while (true) {
            if let c = peek(), c.isDigit(prefixStr) || isUnderScore && c.isUnderScore() {
                isUnderScore = c.isDigit(prefixStr)
                nextPos()
            } else {
                break
            }
        }

        if !isUnderScore {
            error("failed to parse integer \(peek() ?? Character(""))")
        }
    }

    func _num(prefixStr: String, exponent: String) -> String {
        let start = pos
        pos = index(pos: pos, after: prefixStr.count)
        _numIntegerPart(prefixStr: prefixStr)
        // scan fractional part
        if let c = peek(), let c2 = nextPeek(), c == "." && c2.isDigit(prefixStr) {
            nextPos()
            _numIntegerPart(prefixStr: prefixStr)
        }
        // scan exponential part
        if expect(want: exponent.lowercased(), startPos: pos) || expect(want: exponent.uppercased(), startPos: pos) {
            nextPos()
            if let c = peek(), ["+", "-"].contains(c) {
                nextPos()
            }
            _numIntegerPart(prefixStr: prefixStr)
        }
        return getStr(start)
    }

    func number() -> String? {
        if isAtEnd {
            return nil
        }
        if expect(want: Character.prefixHex, startPos: pos) {
            return hexNum()
        }
        if expect(want: Character.prefixOct, startPos: pos) {
            return octNum()
        }
        if expect(want: Character.prefixBin, startPos: pos) {
            return binNum()
        }
        return decNum()
    }

    func error(_ str: String) {
        fatalError(str)
    }

    func expect(want: String, startPos: SIndex) -> Bool {
        let endPos = index(pos: startPos, after: want.count)
        return want == _getStr(startPos, endPos)
    }
}