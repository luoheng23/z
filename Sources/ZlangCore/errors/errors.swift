
enum Reporter {
    case scanner
    case parser
    case checker
    case generator
}

struct Error {
    var message: String
    var details: String
    var filePath: String
    var pos: Position
    var backtrace: String
    var reporter: Reporter
}

struct Warning {
    var message: String
    var details: String
    var filePath: String
    var pos: Position
    var reporter: Reporter
}