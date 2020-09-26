//
//  SwiftScannerTests.swift
//  SwiftScannerTests
//
//  Created by Daniele Margutti on 06/12/2016.
//  Copyright © 2016 Daniele Margutti. All rights reserved.
//

import XCTest

@testable import ZlangCore

final class TokenTests: XCTestCase {

  func testBuildKeys() {
    let keys = Kind.buildKeys()

    for (key, value) in keys {
      XCTAssert(key == value.rawValue, "Failed to validate token key: " + key)
    }
    XCTAssert(
      Set<Kind>(Kind.keywords) == Set<Kind>(keys.values), "Failed to validate token keywords")
  }

  func testAssign() {
    let assign = ["=", "+=", "-=", "*=", "**=", "/=", "^=", "%=", "|=", "&=", ">>=", "<<="]

    for ass in assign {
      XCTAssert(Kind(rawValue: ass)?.isAssign() != nil, "Failed to test assign: " + ass)
    }
    XCTAssert(Kind.Assigns.count == assign.count, "Failed to test assign length.")
  }

  func testDecl() {
    let decl = ["enum", "interface", "fn", "struct", "let", "type", "var", "impl"]
    for dec in decl {
      XCTAssert(Kind(rawValue: dec)?.isDecl() != nil, "Failed to test decl: " + dec)
    }
    XCTAssert(Kind.Decls.count == decl.count, "Failed to test decl length.")
  }

  func testSplit() {
    let split = ["(", ")", "{", "}", "[", "]", "?", ",", ":", ";", "\""]
    for spt in split {
      XCTAssert(Kind(rawValue: spt)?.isDecl() != nil, "Failed to test split: " + spt)
    }
    XCTAssert(Kind.Splits.count == split.count, "Failed to test split length.")
  }

  static var allTests = [
    ("testDecl", testDecl),
    ("testAssign", testAssign),
    ("testSplit", testSplit),
    ("testBuildKeys", testBuildKeys),
  ]
}
