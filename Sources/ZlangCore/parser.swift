
import Files

public class Parser {
    var scan: Scanner
    public var filePath: String
    var table: ZTable

    public init(_ filename: String) {
        scan = Scanner(filePath: filename)
        filePath = filename.split(separator: ".")[0] + ".swift"
        table = ZTable()
        table.initTable()
    }


    public func parseToFile() {
        var tok: ScanRes
        if let file = try? File(path: filePath) {
            _ = try? file.write("")
            repeat {
                tok = scan.scan()
                if tok.tok == Token.eof {
                    break
                }
                let v = tok.lit == "" ? tok.tok.rawValue : tok.lit
                _ = try? file.append(table.getValue(v))
            } while true
        }
    }
}