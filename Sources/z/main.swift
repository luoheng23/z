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

  task.standardOutput = FileHandle.standardOutput
  task.standardInput = FileHandle.standardInput
  task.standardError = FileHandle.standardError

  do {
    if #available(OSX 10.13, *) {
      task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
      try task.run()
      task.waitUntilExit()
    } else {
      task.launchPath = "/usr/bin/env"
      task.launch()
      task.waitUntilExit()
    }
  } catch let err {
    print("err: \(err)")
  }
}

main()
