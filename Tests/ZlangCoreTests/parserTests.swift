
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
        let none = parser.expr()
        XCTAssert(none is None, "Failed to parse None")
    }
    static var allTests = [
        ("testInitParser", testInitParser),
        ("testReadFirstToken", testReadFirstToken),
        ("testBoolLiteral", testBoolLiteral),
        ("testNone", testNone),
    ]
}
