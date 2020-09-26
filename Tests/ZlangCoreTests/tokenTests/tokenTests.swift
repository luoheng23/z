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

  func testWhitespace() {
    let whitespace = ["\t", " ", "\r", "\n"]
    for ws in whitespace {
      XCTAssert(Kind(rawValue: ws)?.isDecl() != nil, "Failed to test whitespace: " + ws)
    }
    XCTAssert(Kind.Whitespace.count == whitespace.count, "Failed to test whitespace length.")
  }

  func testOperators() {
    let operators = ["+", "-", "*", "/", "**", "%", "^", "|", "~", "&", "@", ".", "=", ">", "<"]
    for op in operators {
      XCTAssert(Kind(rawValue: op)?.isDecl() != nil, "Failed to test operators: " + op)
    }
    XCTAssert(Kind.Operators.count == operators.count, "Failed to test operators length.")
  }

  func testKeywords() {
    let keywords = ["and", "break", "case", "let", "continue", "default",
                    "defer", "with", "else", "enum", "impl", "false", "fallthrough", "for",
                    "fn", "go", "if", "import", "in", "interface", "is", "mut", "not", "pub", "or",
                    "static", "struct", "switch", "return", "true", "type", "var", "with"]
    for kw in keywords {
      XCTAssert(Kind(rawValue: kw)?.isDecl() != nil, "Failed to test keywords: " + kw)
    }
    XCTAssert(Kind.keywords.count == keywords.count, "Failed to test keywords length.")
  }

  static var allTests = [
    ("testDecl", testDecl),
    ("testAssign", testAssign),
    ("testSplit", testSplit),
    ("testBuildKeys", testBuildKeys),
    ("testKeywords", testKeywords),
    ("testWhitespace", testWhitespace),
    ("testOperators", testOperators),
  ]
}
