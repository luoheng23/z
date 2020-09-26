import Files
import PathKit

public class Parser {

  static var limitedErrors = 1
  static var limitedWarnings = 1

  static let builtinType = """
  typealias int = Int
  typealias int8 = Int8
  typealias int16 = Int16
  typealias int32 = Int32
  typealias int64 = Int64
  typealias uint = UInt
  typealias uint8 = UInt8
  typealias uint16 = UInt16
  typealias uint32 = UInt32
  typealias uint64 = UInt64
  typealias float = Float
  typealias double = Double
  typealias char = Character
  typealias string = String
  typealias list = Array
  typealias dict = Dictionary

  """
  public var originPath: String
  public var filePath: String

  var scanner: Scanner
  var tok: Token = Token()
  var preTok: Token = Token()
  var peekTok: Token = Token()
  var peekTok2: Token = Token()
  var peekTok3: Token = Token()

  var curFnName: String = ""

  var mod: String = ""
  var scope: Scope
  var globalScope: Scope = Scope(true)

  var errors: [Error] = []
  var warnings: [Warning] = []

  public init(_ filePath: String) {
    self.originPath = filePath
    self.filePath = String(filePath.split(separator: ".")[0] + ".swift")
    self.scope = globalScope

    if let data = try? Path(filePath).read() {
      self.scanner = Scanner(
        file: ZFile(filePath, data.count), src: String(decoding: data, as: UTF8.self))
    } else {
      self.scanner = Scanner("")
      error("unknown file: \(filePath)")
    }

  }

  public init(str: String) {
    self.originPath = ""
    self.filePath = ""
    self.scope = globalScope
    self.scanner = Scanner(str)
  }

  func readFirstToken() {
    for _ in 1...4 {
      check(.unknown, true)
    }
  }

  func openScope() {
    scope = Scope(parent: scope, pos: tok.pos)
  }

  func closeScope() {
    if scope === globalScope {
      fatalError("unexpected close global scope")
    }
    scope.parent!.children.append(scope)
    scope = scope.parent!
  }

  func next() {
    preTok = tok
    tok = peekTok
    peekTok = peekTok2
    peekTok2 = peekTok3
    peekTok3 = scanner.scan()
  }

  func endStmt() {
    while !isTok(.nl) {
      next()
      if !isTok(.space) && !isTok(.nl) {
        check(.nl)
        return
      }
    }
  }

  func eatToEndOfLine() {
    var scan = scanner.scan()
    while scan.kind != .nl && scan.kind != .eof {
      scan = scanner.scan()
    }
  }

  @discardableResult
  func check(_ expected: Kind, _ skip: Bool = false) -> Token {
    if !skip && !isTok(expected) {
      error("unexpected token '\(tok.text())', expecting '\(expected.text())'")
      return Token()
    }
    next()
    return preTok
  }

  func isTok(_ expected: Kind) -> Bool {
    return tok.kind == expected
  }

  func isNextTok(_ expected: Kind) -> Bool {
    return peekTok.kind == expected
  }

  func tryCreateFile() -> Bool {
    let path = Path(filePath)
    if !path.exists {
      do {
        let folder = try Folder(path: ".")
        try path.mkpath()
      } catch let err {
        print(err)
        return false
      }
    }
    return true
  }

  public func parseToFile() {
    if !tryCreateFile() {
      return
    }
    let module = stmts()
  
    if let file = try? File(path: filePath) {
      _ = try? file.write("")
      _ = try? file.append(Parser.builtinType)
      _ = try? file.append(module.gen())
    }
  }
}
