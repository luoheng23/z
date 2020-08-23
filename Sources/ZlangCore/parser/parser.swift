
import Files

public class parser {
    var scan: Scanner
    public var filePath: String
    var table: Table

    public init(_ filename: String) {
        scan = Scanner(filePath: filename)
        filePath = filename.split(separator: ".")[0] + ".swift"
        table = Table()
    }


    public func parseToFile() {
        var tok: Token
        if let file = try? File(path: filePath) {
            _ = try? file.write("")
            repeat {
                tok = scan.scan()
                if tok.isKind(.eof) {
                    break
                }
                let v = tok.lit == "" ? tok.kind.rawValue : tok.lit
                _ = try? file.append(table.getValue(v))
            } while true
        }
    }
}