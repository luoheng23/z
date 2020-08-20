
import Foundation
import ZlangCore

func main() {
    if CommandLine.argc <= 1 {
        print("USAGE: ./z target.z")
        return
    }
    let parser = Parser(CommandLine.arguments[1])
    parser.parseToFile()
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    task.standardOutput = FileHandle.standardOutput
    task.standardInput = FileHandle.standardInput
    task.standardError = FileHandle.standardError
    task.arguments = ["swift", parser.filePath]
    do {
        try task.run()
    } catch let err {
        print("err: \(err)")
    }
    task.waitUntilExit()
}

main()