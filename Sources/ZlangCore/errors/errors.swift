
enum Reporter {
    case scanner
    case parser
    case checker
    case generator
}

class ErrorBase {
    var message: String
    var details: String
    var filePath: String
    var pos: Position
    var reporter: Reporter

    init() {
        self.message = ""
        self.details = ""
        self.filePath = ""
        self.pos = Position()
        self.reporter = .parser
    }
}

class Error: ErrorBase {
    var backtrace: String

    override init() {
        self.backtrace = ""
        super.init()
    }

}

class Warning: ErrorBase {}