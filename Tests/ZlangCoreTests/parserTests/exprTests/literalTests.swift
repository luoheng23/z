
import XCTest

@testable import ZlangCore

final class LiteralTests: BaseExprTests {

    func testBoolLiteral() {
        var str = """
        true
        false
        """
        singleExprTest(str, BoolLiteral.self)
        str = """
        True
        False
        tRuE
        FaLse
        falsE
        TRUE
        FALSE
        """
        singleExprNotTest(str, BoolLiteral.self)
    }

    func testNoneLiteral() {
        var str = """
        nil
        """
        singleExprTest(str, NoneLiteral.self)
        str = """
        none
        None
        NIL
        NULL
        """
        singleExprNotTest(str, NoneLiteral.self)
    }

    func testNumberLiteral() {
        let str = [
        "0 12032",
        "-324",
        "+5789",
        "0132134",
        "-3234324",
        ]
        multiExprTests(str, IntegerLiteral.self)
    }

    static var allTests = [
        ("testBoolLiteral", testBoolLiteral),
        ("testNoneLiteral", testNoneLiteral),
        ("testNumberLiteral", testNumberLiteral),
    ]
}