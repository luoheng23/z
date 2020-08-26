import Foundation

extension Parser {

    func error(_ str: String) {
        errorWithPos(str, tok.pos)
    }

    func warn(_ str: String) {
        warnWithPos(str, tok.pos)
    }

    func errorWithPos(_ str: String, _ pos: Position) {
        eatToEndOfLine()
        let error = Error(message: str,
            details: scanner.getLineInfo(pos),
            filePath: filePath,
            pos: pos)
        errors.append(error)
        if errors.count > Parser.limitedErrors {
            for error in errors {
                error.printError()
            }
            exit(1)
        }
        readFirstToken()
    }

    func warnWithPos(_ str: String, _ pos: Position) {
        let warning = Warning(message: str,
            details: scanner.getLineInfo(pos),
            filePath: filePath,
            pos: pos)
        warnings.append(warning)
        if warnings.count > Parser.limitedWarnings {
            for warning in warnings {
                warning.printError()
            }
            exit(1)
        }
    }
}