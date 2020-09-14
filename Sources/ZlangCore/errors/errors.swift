
import ConsoleColor

enum Warnings {
    case unusedVariable
    case unchangedVariable
}

// TODO
enum Errors {
    case invalidTypeAnnotation
    case unknownVariable
    case localVariableUsedBeforeDeclaration
    case changedConstVariable
    case unfitTwoVariable
    case invalidOperation

    static func getErrorMessage(_ error: Errors, _ expr: Expr) -> String {
        switch (error) {
        case .invalidTypeAnnotation:
            return "invalid type annotation '\(expr.text())'"
        case .unknownVariable:
            return "use of unresolved identifier '\(expr.text())'"
        default:
            return "unknown error"
        }
    }
}

class ErrorBase {
    var message: String
    var details: String
    var filePath: String
    var pos: Position
    var type: String

    init(_ type: String) {
        self.message = ""
        self.details = ""
        self.filePath = ""
        self.type = type
        self.pos = Position()
    }

    init(_ message: String, _ details: String, _ filePath: String, _ pos: Position, _ type: String) {
        self.message = message
        self.details = details
        self.filePath = filePath
        self.pos = pos
        self.type = type
    }

    func setColor() {}

    func printError() {
        setColor()
        print("\(filePath):\(pos.lineNr):\(pos.startPos): \(type): \(message)")
        print(details)
        for _ in 0..<pos.pos {
            print(" ", terminator: "")
        }
        var p = "^"
        p.applyCCFormat(textColor: .green)
        print(p)
    }
}

class Error: ErrorBase {

    static var limitedErrors = 20

    init(message: String, details: String, filePath: String, pos: Position) {
        super.init(message, details, filePath, pos, "error")
    }

    override func setColor() {
        type.applyCCFormat(textColor: .red)
    }

}

class Warning: ErrorBase {
    static var limitedWarnings = 1

    init() {
        super.init("warning")
    }

    override func setColor() {
        type.applyCCFormat(textColor: .magenta)
    }

    init(message: String, details: String, filePath: String, pos: Position) {
        super.init(message, details, filePath, pos, "warning")
    }
}