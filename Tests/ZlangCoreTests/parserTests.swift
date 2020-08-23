
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
        let filename = "test.swift"
        XCTAssertFalse(folder.containsFile(named: filename))
        let file = try? folder.createFile(named: filename)
        XCTAssert(file != nil && file!.name == filename)
        let parser = Parser(filePath: folder.path + filename)
        XCTAssert(parser.filePath == folder.path + filename, "init parser filename failed.")
    }

    
    static var allTests = [
        ("testInitParser", testInitParser),
    ]
}
