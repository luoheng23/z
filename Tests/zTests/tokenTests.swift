//
//  SwiftScannerTests.swift
//  SwiftScannerTests
//
//  Created by Daniele Margutti on 06/12/2016.
//  Copyright © 2016 Daniele Margutti. All rights reserved.
//

import XCTest

@testable import z

final class TokenTests: XCTestCase {

  func testBuildKeys() {
    let keys = Token.buildKeys()

    for (key, value) in keys {
      XCTAssert(key == value.rawValue, "Failed to validate token key: " + key)
    }
    XCTAssert(
      Set<Token>(Token.keywords) == Set<Token>(keys.values), "Failed to validate token keywords")
  }

  func testAssign() {
    let assign = ["=", "+=", "-=", "*=", "/=", "^=", "%=", "|=", "&=", ">>=", "<<="]

    for ass in assign {
      XCTAssert(Token(rawValue: ass)?.isAssign() != nil, "Failed to test assign: " + ass)
    }
    XCTAssert(Token.Assigns.count == assign.count, "Failed to test assign length.")
  }

  func testDecl() {
    let decl = ["enum", "interface", "fn", "struct", "const", "type", "var", "mut", "pub"]
    for dec in decl {
      XCTAssert(Token(rawValue: dec)?.isDecl() != nil, "Failed to test decl: " + dec)
    }
    XCTAssert(Token.Decls.count == decl.count, "Failed to test decl length.")
  }

  static var allTests = [
    ("testDecl", testDecl),
    ("testAssign", testAssign),
    ("testBuildKeys", testBuildKeys),
  ]
}
