class Position: Object {
    var filename: String
    var line: Int
    var column: Int
    var offset: Int

    override init() {
        self.filename = ""
        self.line = 0
        self.column = 0
        self.offset = 0
    }

    init(_ filename: String, _ offset: Int, _ line: Int, _ column: Int) {
        self.filename = filename
        self.offset = offset
        self.line = line
        self.column = column
    }

    init(_ pos: Position) {
        self.filename = pos.filename
        self.offset = pos.offset
        self.line = pos.line
        self.column = pos.column
    }

    func isValid() -> Bool {
        return self.line > 0
    }

    override var description: String {
        var str = self.filename
        if self.isValid() {
            if str != "" {
                str += ":"
            }
            str += String(self.line)
            if self.column != 0 {
                str += ":" + String(self.column)
            }
        }
        if str == "" {
            str = "-"
        }
        return str
    }
}
