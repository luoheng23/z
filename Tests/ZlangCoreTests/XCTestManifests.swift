import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TokenTests.allTests),
        testCase(ScannerTests.allTests),
        testCase(LiteralTests.allTests),
        testCase(ExprTests.allTests),
        testCase(DeclTests.allTests),
    ]
}
#endif
