
class FileSet {}
class lineInfo {}

class ZFile {
    var fileSet: FileSet = FileSet()
    var name: String = ""
    var base: Int = 0
    var size: Int = 0

    var lines: [SIndex] = []
    var infos: [lineInfo] = []


    func lineCount() -> Int {
        return lines.count
    }

    func addLine(_ offset: SIndex) {
        lines.append(offset)
    }

    func mergeLine(_ line: Int) {
        if line >= lineCount() {
            fatalError("illegal line number")
        }
        lines[line...line+2] = [lines[line]]
    }

    func setLines(_ lines: [SIndex]) {}
}