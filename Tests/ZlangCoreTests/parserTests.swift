
//
//  SwiftScannerTests.swift
//  SwiftScannerTests
//
//  Created by Daniele Margutti on 06/12/2016.
//  Copyright © 2016 Daniele Margutti. All rights reserved.
//

import XCTest
import Files

@testable import ZlangCore

final class ParserTests: XCTestCase {

    private var folder: Folder!

    override func setUp() {
        super.setUp()
        folder = try! Folder.home.createSubfolderIfNeeded(withName: ".filesTest")
        try! folder.empty()
    }

    override func tearDown() {
        try! folder.delete()
        super.tearDown()
    }

    func testInitParser() {
        let filename = "test.z"
        XCTAssertFalse(folder.containsFile(named: filename))
        let file = try? folder.createFile(named: filename)
        XCTAssert(file != nil && file!.name == filename)
        let parser = Parser(filePath: folder.path + filename)
        XCTAssert(parser.filePath == folder.path + filename, "init parser filename failed.")
    }

    func testReadFirstToken() {
        let str = """
        hello world
        this-isgood
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        XCTAssert(parser.tok.lit == "hello", "Failed to test readFirstToken: \(parser.tok.lit) != 'hello'")
        XCTAssert(parser.peekTok.lit == "world", "Failed to test readFirstToken: \(parser.tok.lit) != 'world'")
        XCTAssert(parser.peekTok2.lit == "this", "Failed to test readFirstToken: \(parser.tok.lit) != 'this'")
        XCTAssert(parser.peekTok3.lit == "-", "Failed to test readFirstToken: \(parser.tok.lit) != '-'")
    }

    func testBoolLiteral() {
        let str = """
        true false
        fill
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let first = parser.expr()
        let second = parser.expr()
        XCTAssert(first is BoolLiteral && second is BoolLiteral, "Failed to parse boolLiteral")
        XCTAssert((first as! BoolLiteral).bool == true)
        XCTAssert((second as! BoolLiteral).bool == false)
    }

    func testNone() {
        let str = """
        nil
        wia
        wis
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let none = parser.expr() as! None
        XCTAssert(none.text() == "nil", "Failed to parse None")
    }

    func testComments() {
        let str = """
        # hello world
        # good day
        # it's all right
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let first = parser.expr() as! Comment
        let second = parser.expr() as! Comment
        let third = parser.expr() as! Comment
        let answer = str.split(separator: "\n")
        XCTAssert(first.text() == answer[0], "Failed to parse comment: \(first.text()) != \(answer[0])")
        XCTAssert(second.text() == answer[1], "Failed to parse comment: \(second.text()) != \(answer[1])")
        XCTAssert(third.text() == answer[2], "Failed to parse comment: \(third.text()) != \(answer[2])")
    }

    func testEnumVal() {
        let str = """
        .hello
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let first = parser.expr() as! EnumVal
        let answer = str.split(separator: "\n")
        XCTAssert(first.text() == answer[0], "Failed to parse EnumVal: \(first.text()) != \(answer[0])")
    }

    func testTuple() {
        let str = """
        (.hello)
        (.good)
        (.zzr)
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let first = parser.expr() as! TupleExpr
        let second = parser.expr() as! TupleExpr
        let third = parser.expr() as! TupleExpr
        let answer = str.split(separator: "\n")
        XCTAssert(first.text() == answer[0], "Failed to parse TupleExpr: \(first.text()) != \(answer[0])")
        XCTAssert(second.text() == answer[1], "Failed to parse TupleExpr: \(second.text()) != \(answer[1])")
        XCTAssert(third.text() == answer[2], "Failed to parse TupleExpr: \(third.text()) != \(answer[2])")
    }

    func testPrefixExpr() {
        let str = """
        -hello
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let first = parser.expr() as! PrefixExpr
        let answer = str.split(separator: "\n")
        XCTAssert(first.text() == answer[0], "Failed to parse PrefixExpr: \(first.text()) != \(answer[0])")
    }

    func testSelectorExpr() {
        let str = """
        .hello
        .good
        .day
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let first = parser.expr() as! SelectorExpr
        let answer = str.split(separator: "\n").joined(separator: "")
        XCTAssert(first.text() == answer, "Failed to parse SelectorExpr: \(first.text()) != \(answer)")
    }


    func testIndexExpr() {
        let str = """
        hello[.good.day]
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let first = parser.expr() as! IndexExpr
        let answer = str.split(separator: "\n").joined(separator: "")
        XCTAssert(first.text() == answer, "Failed to parse IndexExpr: \(first.text()) != \(answer)")
    }

    func testInfixExpr() {
        let str = """
        hello[.good.day] + world[hello[good]]
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let first = parser.expr() as! InfixExpr
        let left = first.left as! IndexExpr
        let right = first.right as! IndexExpr
        let op = first.op
        let answer = str.split(separator: " ")
        XCTAssert(left.text() == answer[0], "Failed to parse InfixExpr: \(first.text()) != \(answer[0])")
        XCTAssert(op.str() == answer[1], "Failed to parse InfixExpr: \(op.str()) != \(answer[1])")
        XCTAssert(right.text() == answer[2], "Failed to parse InfixExpr: \(right.text()) != \(answer[2])")
    }


    func testVarAndConstDecl() {
        let str = """
        var s = 20
        var (s, t) = (20, 30)
        const s = 20
        const (s, t) = (20, 30)
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        var first = parser.stmt() as! NameDecl
        var second = parser.stmt() as! TupleDecl
        let answer = str.split(separator: "\n")
        XCTAssert(first.text() == answer[0], "Failed to parse VarAndConstDecl: \(first.text()) != \(answer[0])")
        XCTAssert(second.text() == answer[1], "Failed to parse VarAndConstDecl: \(second.text()) != \(answer[1])")
        first = parser.stmt() as! NameDecl
        second = parser.stmt() as! TupleDecl
        XCTAssert(first.text() == answer[2], "Failed to parse VarAndConstDecl: \(first.text()) != \(answer[2])")
        XCTAssert(second.text() == answer[3], "Failed to parse VarAndConstDecl: \(second.text()) != \(answer[3])")
    }

    func testTypeDecl() {
        let str = """
        type s = 20
        type s 20
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let first = parser.stmt() as! TypeDecl
        let second = parser.stmt() as! TypeDecl
        let answer = str.split(separator: "\n")
        XCTAssert(first.text() == answer[0], "Failed to parse TypeDecl: \(first.text()) != \(answer[0])")
        XCTAssert(second.text() == answer[1], "Failed to parse TypeDecl: \(second.text()) != \(answer[1])")
    }

    func testStructDecl() {
        let str = """
        struct name {
            var hello = 20
            var good = 30
        }
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let first = parser.stmt() as! StructDecl
        let answer = str
        XCTAssert(first.text() == answer, "Failed to parse StructDecl: \(first.text()) != \(answer)")
    }

    func testEnumDecl() {
        let str = """
        enum name {
            var hello = 20
            var good = 30
        }
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let first = parser.stmt() as! EnumDecl
        let answer = str
        XCTAssert(first.text() == answer, "Failed to parse EnumDecl: \(first.text()) != \(answer)")
    }

    func testInterfaceDecl() {
        let str = """
        interface name {
            var hello = 20
            var good = 30
        }
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let first = parser.stmt() as! InterfaceDecl
        let answer = str
        XCTAssert(first.text() == answer, "Failed to parse InterfacetDecl: \(first.text()) != \(answer)")
    }

    func testImplDecl() {
        let str = """
        impl name {
            var hello = 20
            var good = 30
        }
        """
        let parser = Parser(str: str)
        parser.readFirstToken()
        let first = parser.stmt() as! ImplDecl
        let answer = str
        XCTAssert(first.text() == answer, "Failed to parse ImpltDecl: \(first.text()) != \(answer)")
    }

    static var allTests = [
        ("testInitParser", testInitParser),
        ("testReadFirstToken", testReadFirstToken),
        ("testBoolLiteral", testBoolLiteral),
        ("testNone", testNone),
        ("testComments", testComments),
        ("testEnumVal", testEnumVal),
        ("testTuple", testTuple),
        ("testPrefixExpr", testPrefixExpr),
        ("testSelectorExpr", testSelectorExpr),
        ("testIndexExpr", testIndexExpr),
        ("testInfixExpr", testInfixExpr),
        ("testVarAndConstDecl", testVarAndConstDecl),
        ("testTypeDecl", testTypeDecl),
        ("testStructDecl", testStructDecl),
        ("testEnumDecl", testEnumDecl),
        ("testImplDecl", testImplDecl),
        ("testInterfaceDecl", testInterfaceDecl),
    ]
}
