import Files
import XCTest

@testable import ZlangCore

//
//  SwiftScannerTests.swift
//  SwiftScannerTests
//
//  Created by Daniele Margutti on 06/12/2016.
//  Copyright © 2016 Daniele Margutti. All rights reserved.
//

final class ScannerTests: XCTestCase {

    func testName() {
        let str = "name hello good th 恶魔"
        let answer = str.split(separator: " ")
        let scanner = Scanner(str)
        for word in answer {
            let name = scanner.scan().lit
            scanner.skipWhitespace()
            XCTAssert(
                name == word,
                "Failed scanner name test: \(word) != \(name), \(word.count) != \(name.count)"
            )
        }
    }

    func testNumber() {
        let str =
            "123 123.123 456.456 12e10 12.2e+10 12.2e-10 1_2_2_3.3_4_4_5e10 0o7 0xF 0b0101"
        let answer = str.split(separator: " ")
        let scanner = Scanner(str)
        for word in answer {
            let number = scanner.scan().lit
            scanner.skipWhitespace()
            XCTAssert(
                number == word,
                "Failed scanner number test: \(word) != \(number), \(word.count) != \(number.count)"
            )

        }
    }

    func testString() {
        let str =
            """
            "hello world"
            "hello {this is good} day"
            "this {this is good} {good}"
            """
        let answer = str.split(separator: "\n")
        let scanner = Scanner(str)
        for word in answer {
            let string = scanner.scan().lit
            scanner.skipWhitespace()
            XCTAssert(
                word == string,
                "Failed scanner string test: \(word) != \(string), \(word.count) != \(name.count)"
            )
        }
    }

    func testScan() {
        let str = """
            let a = 10
            var b = 20
            print(a + b)
            """
        let answer = [
            "let", "a", "=", "10", "var", "b", "=", "20", "print", "(", "a",
            "+", "b", ")",
        ]
        let scanner = Scanner(str)
        for word in answer {
            let name = scanner.scan().lit
            scanner.skipWhitespace()
            XCTAssert(
                word == name,
                "Failed scanner scan test: \(word) != \(name), \(word.count) != \(name.count)"
            )
        }
    }

    func testNameWithDot() {
        let str = """
            .hello .zzr
            """
        let answer = [".", "hello", ".", "zzr"]
        let scanner = Scanner(str)
        for word in answer {
            let name = scanner.scan().lit
            scanner.skipWhitespace()
            XCTAssert(
                word == name,
                "Failed scanner scan test: \(word) != \(name), \(word.count) != \(name.count)"
            )
        }
    }

    func testComment() {
        let str =
            """
            # comment1
            # comment2
            # comment3
            # comment4
            # comment5
            """
        let answer = str.split(separator: "\n")
        let scanner = Scanner(str)
        for word in answer {
            let name = scanner.scan().lit
            scanner.skipWhitespace()
            XCTAssert(
                word == name,
                "Failed scanner scan comment test: \(word) != \(name), \(word.count) != \(name.count)"
            )
        }
    }

    func testOperator() {
        let str = "+ - * / % ** += -= *= /= %= **= & | &= |= ^= ^"
        let answer = str.split(separator: " ")
        let scanner = Scanner(str)
        for word in answer {
            let number = scanner.scan().lit
            scanner.skipWhitespace()
            XCTAssert(
                number == word,
                "Failed scanner number test: \(word) != \(number), \(word.count) != \(number.count)"
            )

        }
    }

    static var allTests = [
        ("testName", testName),
        ("testScan", testScan),
        ("testNumber", testNumber),
        ("testString", testString),
        ("testComment", testComment),
        ("testOperator", testOperator),
        ("testNameWithDot", testNameWithDot),
    ]
}
