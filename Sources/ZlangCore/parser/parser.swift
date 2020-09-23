import Files

public class Parser {

  static var limitedErrors = 1
  static var limitedWarnings = 1

  static let builtinType = "Sources/ZlangCore/code-generator/typealias.swift"
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
    if let data = try? (try? File(path: Parser.builtinType))?.read() {
      self.scanner = Scanner(file: ZFile(filePath, data.count), src: String(decoding: data, as: UTF8.self))
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

  func next(_ skipWhitespace: Bool = true) {
    preTok = tok
    tok = peekTok
    peekTok = peekTok2
    peekTok2 = peekTok3
    peekTok3 = scanner.scan(skipWhitespace)
  }

  func endStmt() {
    while !isTok(.nl) {
      next(false)
      if !isTok(.space) && !isTok(.nl) {
        check(.nl)
        return
      }
    }
  }

  func eatToEndOfLine() {
    var scan = scanner.scan(false)
    while scan.kind != .nl && scan.kind != .eof {
      scan = scanner.scan(false)
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

  public func parseToFile() {
    let module = stmts()
    if let file = try? File(path: filePath),
      let typ = try? (try? File(path: Parser.builtinType))?.read() {
      _ = try? file.write("")
      _ = try? file.append(String(decoding: typ, as: UTF8.self))
      _ = try? file.append(module.gen())
    }
  }
}
