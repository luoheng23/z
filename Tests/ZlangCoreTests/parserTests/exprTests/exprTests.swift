import XCTest

@testable import ZlangCore

final class ExprTests: BaseTests {

  func testNameExpr() {
    let str = [
      "hello",
      "good",
      "strange",
      "value",
      "int",
      "恶魔",
      "奇怪的语言",
      "emoji",
      "爱",
    ]

    multiExprTests(str, NameExpr.self)
  }

  func testEnumVal() {
    let str = [
      ".hello",
      ".good",
      ".strange",
      ".value",
      ".int",
    ]

    multiExprTests(str, EnumValueExpr.self)
  }

  func testTuple() {
    let str = [
      "(.hello)",
      "(.good)",
      "(.zzr)",
      "(.zzr, .hfsd)",
      "(.zzr, .hfsd, sdfsdfs)",
      "()",
      "(dsfaf, fsdfs, fsdfsaf)",
    ]
    multiExprTests(str, TupleExpr.self)
  }

  func testPrefixExpr() {
    let str = [
      "-hello",
      "+hello",
      "-hello",
      "+1.2",
      "-hello.good",
      "-hello[good]",
    ]
    multiExprTests(str, PrefixExpr.self)
  }

  func testDotExpr() {
    let str = [
      "g.hello",
      "g.good",
      "g.day",
    ]
    multiExprTests(str, DotExpr.self)
  }

  func testIndexExpr() {
    let str = """
      hello[.good.day]
      hello[30 + 20]
      """
    singleExprTest(str, IndexExpr.self)
  }

  func testInfixExpr() {
    let str = """
      hello[.good.day] + world[hello[good]]
      5 + 2
      30 + 40
      hello.good - dfjdsf ** ttt
      """
    singleExprTest(str, InfixExpr.self)
  }

  func testIfElseExpr() {
    let str = [
      "hello ? good : right",
      ".hello ? yes.g : ok",
    ]
    multiExprTests(str, IfElseExpr.self)
  }

  func testCallExpr() {
    let str = [
      "hello(good, write)",
      "hello()",
      "yes.yes[good]()",
      "hello()",
    ]
    multiExprTests(str, CallExpr.self)
  }

  func testIsInAsExpr() {
    let str = [
      "hello in world",
      "hello is world",
      "hello and world",
      "hello or world",
    ]
    multiExprTests(str, InfixExpr.self)
  }

  static var allTests = [
    ("testNameExpr", testNameExpr),
    ("testEnumVal", testEnumVal),
    ("testTuple", testTuple),
    ("testPrefixExpr", testPrefixExpr),
    ("testDotExpr", testDotExpr),
    ("testIndexExpr", testIndexExpr),
    ("testInfixExpr", testInfixExpr),
    ("testIfElseExpr", testIfElseExpr),
    ("testCallExpr", testCallExpr),
    ("testIsInAsExpr", testIsInAsExpr),
  ]
}
