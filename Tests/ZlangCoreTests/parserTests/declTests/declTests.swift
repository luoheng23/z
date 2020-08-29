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
          fn name() (t Int) {}
      }
      """
    ]
    multiExprTests(str, StructDecl.self, "", .decl)
  }

  func testEnumDecl() {
    let str = [
      """
      enum name {
          case good
          case hello
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
          fn name() (t Int) {}
      }
      """
    ]
    multiExprTests(str, EnumDecl.self, "", .decl)
  }

  func testImplDecl() {
    let str = [
      """
      impl name {
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
          fn name() (t Int) {}
      }
      """
    ]
    multiExprTests(str, ImplDecl.self, "", .decl)
  }

  func testInterfaceDecl() {
    let str = [
      """
      interface name {
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
          fn name() (t Int) {}
      }
      """
    ]
    multiExprTests(str, InterfaceDecl.self, "", .decl)
  }

  func testFnDecl() {
    let str = """
      fn hello(var a Int, b Int) {
          var hello String = "50"
          print(hello)
      }
      """
      singleExprTest(str, FnDecl.self, "", .decl)
  }

  static var allTests = [
    ("testVarAndConstDecl", testVarAndConstDecl),
    ("testTypeDecl", testTypeDecl),
    ("testStructDecl", testStructDecl),
    ("testEnumDecl", testEnumDecl),
    ("testInterfaceDecl", testInterfaceDecl),
    ("testImplDecl", testImplDecl),
    ("testFnDecl", testFnDecl),
  ]

}
