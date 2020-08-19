
import Files

class Parser {
    var scan: ZScanner
    var filePath: String
    var table: Table

    init(_ filename: String) {
        scan = ZScanner(filePath: filename)
        filePath = filename.split(separator: ".")[0] + ".swift"
        table = Table()
        table.initTable()
    }


    func parseToFile() {
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