
class Whitespace {
    
    typealias whiteSpace = UInt8

    static let ignore = whiteSpace(0)
    static let blank = whiteSpace(" ")
    static let vtab = whiteSpace("\v")
    static let newline = whiteSpace("\n")
    static let formfeed = whiteSpace("\f")
    static let indent = whiteSpace(">")
    static let unindent = whiteSpace("<")
}

class CommentGroup {}
class CommentInfo {
    var cindex: Int
    var comment: CommentGroup
    var commentOffset: Int
    var commentNewline: Bool
}

let maxNewlines = 2
let infinity = 1 << 30

var debug = false

class Config {}
class Printer {
    var cfg: Config

    
}