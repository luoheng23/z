import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(zTests.allTests),
        testCase(TokenTests.allTests),
        testCase(ZScannerTests.allTests),
    ]
}
#endif
