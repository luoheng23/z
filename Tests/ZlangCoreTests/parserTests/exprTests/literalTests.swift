import XCTest

@testable import ZlangCore

final class LiteralTests: BaseTests {

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

    func testIntegerLiteral() {
        var str = [
            "12032",
            "0",
            "01234",
            "324",
            "5789",
            "132134",
            "3234324",
            "3_2_4_5_6",
            "0b0101",
            "0b0_1_0_1",
            "0o070707",
            "0o0_70_70_7",
            "0xFADCE123",
            "0xFADC_E123",
        ]
        multiExprTests(str, IntegerLiteral.self)
        str = [
            "-324",
            "+4234",
        ]
        multiExprNotTests(str, IntegerLiteral.self)
    }

    func testFloatLiteral() {
        var str = [
            "12032.0",
            "0.2",
            "01234.3",
            "324.4",
            "5789e+0",
            "132134e23",
            "3234324E-12",
            "3_2_4_5_6E3",
            "0b0101p+1",
            "0b0_1_0_1p-1",
            "0o070707p2",
            "0o0_70_70_7P3",
            "0xFADCE123P+24E",
            "0xFADC_E123P-23f",
        ]
        multiExprTests(str, FloatLiteral.self)
        str = [
            "-324.23",
            "+4234.4",
        ]
        multiExprNotTests(str, FloatLiteral.self)
    }

    func testStringLiteral() {
        let str = #"""
            "hello world"
            "hello {} strange"
            """ multi str """
            """#
        singleExprTest(str, StringLiteral.self)
    }

    static var allTests = [
        ("testBoolLiteral", testBoolLiteral),
        ("testNoneLiteral", testNoneLiteral),
        ("testIntegerLiteral", testIntegerLiteral),
        ("testFloatLiteral", testFloatLiteral),
        ("testStringLiteral", testStringLiteral),
    ]
}
