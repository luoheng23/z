
import Foundation
import ZlangCore

func main() {
    if CommandLine.argc <= 1 {
        print("USAGE: ./z target.z")
        return
    }
    let task = Process()
    var parse: Parser
    if CommandLine.arguments.count >= 3 {
       parse = Parser(CommandLine.arguments[2])
       task.arguments = ["swiftc", parse.filePath]
    } else {
        parse = Parser(CommandLine.arguments[1])
        task.arguments = ["swift", parse.filePath]
    }
    parse.parseToFile()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    task.standardOutput = FileHandle.standardOutput
    task.standardInput = FileHandle.standardInput
    task.standardError = FileHandle.standardError
    do {
        try task.run()
    } catch let err {
        print("err: \(err)")
    }
    task.waitUntilExit()
}

main()