import XCTest

@testable import ZlangCore

final class DeclTests: BaseTests {
  func testVarAndConstDecl() {
    var str = [
      "var s = 20",
      "var s String",
      "const s = 20",
      "const s String",
    ]
    multiExprTests(str, NameDecl.self, "", .decl)
    str = [
      "var (s, t) = (20, 30)",
      "var (s Int, t String)",
      "var (s Int, t) = (20, 30)",
      "const (s, t) = (20, 30)",
      "const (s Int, t String)",
      "const (s Int, t) = (20, 30)",
    ]
    multiExprTests(str, TupleNameDecl.self, "", .decl)
  }

  func testTypeDecl() {
    let str = [
      "type s = 20",
      "type s 20",
    ]
    multiExprTests(str, TypeDecl.self, "", .decl)
  }

  func testStructDecl() {
    let str = [
      """
      struct name {
          var s = 20
          var s String
          var (s, t) = (20, 30)
          var (s Int, t String)
          var (s Int, t) = (20, 30)
          const s = 20
          const s String
          const (s, t) = (20, 30)
          const (s Int, t String)
          const (s Int, t) = (20, 30)
          enum name {}
          impl name {}
          fn name() {}
           fn name() Int {}
      }
      """
    ]
    multiExprTests(str, StructDecl.self, "", .decl)
  }

  func testFnDecl() {
    let str = """
      fn hello(var a: Int, b: Int) {
          var hello: String = "50"
      }
      """
    let parser = Parser(str: str)
    parser.readFirstToken()
    // print(parser.stmt().str())
    let first = parser.stmt() as! FnDecl
    let answer = str
    XCTAssert(first.text() == answer, "Failed to parse FnDecl: \(first.text()) != \(answer)")
  }

  static var allTests = [
    ("testVarAndConstDecl", testVarAndConstDecl),
    ("testTypeDecl", testTypeDecl),
    ("testStructDecl", testStructDecl),
    // ("testEnumDecl", testEnumDecl),
    // ("testInterfaceDecl", testInterfaceDecl),
    // ("testImplDecl", testImplDecl),
    ("testFnDecl", testFnDecl),
  ]

}
