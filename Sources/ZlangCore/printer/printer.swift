class Whitespace {

    typealias whiteSpace = UInt8

    static let ignore = whiteSpace(0)
    static let blank = whiteSpace(" ")
    static let newline = whiteSpace("\n")
    static let indent = whiteSpace(">")
    static let unindent = whiteSpace("<")
}

class CommentGroup {}

class CommentInfo {
    var cindex: Int = 0
    var comment: CommentGroup = CommentGroup()
    var commentOffset: Int = 0
    var commentNewline: Bool = true
}

let maxNewlines = 2

let infinity = 1 << 30

var debug = false

class Config {}

class Printer {
    var cfg: Config = Config()

}
