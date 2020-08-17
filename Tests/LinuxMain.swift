import XCTest

import zTests
import tokenTests

var tests = [XCTestCaseEntry]()
tests += zTests.allTests()
XCTMain(tests)
