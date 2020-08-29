//
//  SwiftScannerTests.swift
//  SwiftScannerTests
//
//  Created by Daniele Margutti on 06/12/2016.
//  Copyright © 2016 Daniele Margutti. All rights reserved.
//

import Files
import XCTest

@testable import ZlangCore

enum kind {
  case stmt
  case expr
  case decl
}

class BaseTests: XCTestCase {

  func single<T>(
    _ str: String, _ typeClass: T.Type, _ not: Bool, _ breaker: String = "\n",
    _ defaultKind: kind = .expr
  ) {
    let parser = Parser(str: str)
    parser.readFirstToken()
    let answer = breaker.count == 1 ? str.split(separator: Character(breaker)) : [str[...]]
    for word in answer {
      let token =
        defaultKind == .expr
        ? parser.expr() : (defaultKind == .stmt ? parser.stmt() : parser.decl())
      XCTAssert(
        (type(of: token) == typeClass) == not, "Failed to test \(token.str()) with \(typeClass)")
      XCTAssert(word == token.text(), "Failed to test \(word) != \(token.text())")
    }
  }

  func singleExprTest<T>(
    _ str: String, _ typeClass: T.Type, _ breaker: String = "\n", _ defaultKind: kind = .expr
  ) {
    single(str, typeClass, true, breaker, defaultKind)
  }

  func singleExprNotTest<T>(
    _ str: String, _ typeClass: T.Type, _ breaker: String = "\n", _ defaultKind: kind = .expr
  ) {
    single(str, typeClass, false, breaker, defaultKind)
  }

  func multiExprTests<T>(
    _ strs: [String], _ type: T.Type, _ breaker: String = "\n", _ defaultKind: kind = .expr
  ) {
    for str in strs {
      singleExprTest(str, type, breaker, defaultKind)
    }
  }

  func multiExprNotTests<T>(
    _ strs: [String], _ type: T.Type, _ breaker: String = "\n", _ defaultKind: kind = .expr
  ) {
    for str in strs {
      singleExprNotTest(str, type, breaker, defaultKind)
    }
  }
}
