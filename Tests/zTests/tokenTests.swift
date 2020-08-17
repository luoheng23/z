//
//  SwiftScannerTests.swift
//  SwiftScannerTests
//
//  Created by Daniele Margutti on 06/12/2016.
//  Copyright © 2016 Daniele Margutti. All rights reserved.
//

import XCTest
@testable import Token

class TokenTests: XCTestCase {
	
	func testBuildKeys() {
        let keys = Token.testBuildKeys()

		do {
            for (key, value) in keys {
                XCTAssert(key == value.rawValue, "Failed to validate token keys")
                XCTAssert(Token.keywords.contains(value), "Failed to validate token keywords")
			}
		} catch let err {
			XCTFail("buildKeys() does not work properly: \(err)")
		}
	}
	
	func testAssign() {
        let assign = ["=", "+=", "-=", "*=", "/=", "^=", "%=", "|=", "&=", ">>=", "<<="]

		do {
            for ass in assign {
                XCTAssert(Token(rawValue: ass)?.isAssign(), "Failed to test assign")
            }
		} catch let err {
			XCTFail("testAssign() does not work properly: \(err)")
		}
	}
	
	func testDecl() {
        let decl = ["enum", "interface", "fn", "struct", "const", "type", "var", "mut", "pub"]
		do {
            for dec in decl {
                XCTAssert(Token(rawValue: ass)?.isDecl(), "Failed to test assign")
            }
		} catch let err {
			XCTFail("testFloat() does not work properly: \(err)")
		}
	}
    
    static allTests = [
        ("testDecl", testDecl),
        ("testAssign", testAssign),
        ("testBuildKeys", testBuildKeys),
    ]
}