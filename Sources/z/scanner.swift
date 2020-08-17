
import SwiftFilePath


class Scanner {
    var filePath: String
    var text: String
    var count: Int
    var pos: Int
    var newlineNum: Int
    var lastNewLinePos: Int
    var insideString: Bool
    var interStart: Bool
    var interEnd: Bool
    var debug: Bool
    var lineComment: String
    var started: Bool

    var fileLines: [String]
    var prevTok: Token
    var fnName: String


    init?(filePath: String) {
        if !Path(filePath).exists {
            fatalError("\(filePath) doesn't exist")
        }
        do {
            text = try File(path: filePath).readAsString()
        } catch let err {
            fatalError(err)
        }
        count = text.count
        if count >= 3 {
            if text[text.startIndex] {

            }
        }

    }
}