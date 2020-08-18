//
//  SwiftScannerTests.swift
//  SwiftScannerTests
//
//  Created by Daniele Margutti on 06/12/2016.
//  Copyright © 2016 Daniele Margutti. All rights reserved.
//

import XCTest

@testable import z
import Files

final class scannerTests: XCTestCase {

    private var folder: Folder!

    override func setUp() {
        super.setUp()
        folder = try! Folder.home.createSubfolderIfNeeded(withName: ".filesTest")
        try! folder.empty()
    }

    override func tearDown() {
        try? folder.delete()
        super.tearDown()
    }

    func testInitScanner() {
        let filename = "LinuxMain.swift"
        XCTAssertFalse(folder.containsFile(named: filename))
        let file = try? folder.createFile(named: filename)
        XCTAssert(file != nil && file!.name == filename)
        let scanner = Scanner(filePath: folder.path + filename)
        XCTAssert(scanner.filePath == folder.path + filename, "init scanner filename failed.")
    }

    func testName() {
        let str = "name hello good th 恶魔"
        let answer = str.split(separator: " ")
        let scanner = Scanner(str)
        for word in answer {
            let name = scanner.name() ?? ""
            scanner.skipWhitespace()
            XCTAssert(name == word, "Failed scanner name test: \(word) != \(name), \(word.count) != \(name.count)")
        }
    }

    func testNumber() {
        let str = "123 123.123 456.456 12e10 12.2e+10 12.2e-10 1_2_2_3.3_4_4_5e10 0o7 0xF 0b0101"
        let answer = str.split(separator: " ")
        let scanner = Scanner(str)
        for word in answer {
            let number = scanner.number() ?? ""
            scanner.skipWhitespace()
            XCTAssert(number == word, "Failed scanner number test: \(word) != \(name), \(word.count) != \(name.count)")

        }
    }
    static var allTests = [
        ("testInitScanner", testInitScanner),
        ("testName", testName),
        ("testNumber", testNumber),
    ]
}
