
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

class BaseExprTests: XCTestCase {

    func single<T>(_ str: String, _ typeClass: T.Type, _ not: Bool) {
        let parser = Parser(str: str)
        parser.readFirstToken()
        let answer = str.split(separator: "\n")
        for word in answer {
            let token = parser.expr()
            XCTAssert((type(of: token) == typeClass) == not, "Failed to test \(token.str()) with \(typeClass)")
            XCTAssert(word == token.text(), "Failed to test \(word) != \(token.text())")
        }
    }

    func singleExprTest<T>(_ str: String, _ typeClass: T.Type) {
        single(str, typeClass, true)
    }

    func singleExprNotTest<T>(_ str: String, _ typeClass: T.Type) {
        single(str, typeClass, false)
    }

    func multiExprTests<T>(_ strs: [String], _ type: T.Type) {
        for str in strs {
            singleExprTest(str, type)
        }
    }
}
