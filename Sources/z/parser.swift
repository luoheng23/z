
import Files

class Parser {
    var scan: Scanner
    var filePath: String
    var table: Table

    init(_ filename: String) {
        scan = Scanner(filename)
        filePath = filename.split(separator: ".")[0] + ".swift"
        table = Table()
        table.initTable()
    }


    func parseToFile() {
        var tok: ScanRes
        if let file = try? File(path: filePath) {
            repeat {
                tok = scan.scan()
                _ = try? file.write(table.getValue(tok.lit))
            } while tok.tok != Token.eof
        }
    }


}