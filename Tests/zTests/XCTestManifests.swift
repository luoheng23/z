import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(zTests.allTests),
        testCase(tokenTests.allTests),
        testCase(scannerTests.allTests),
    ]
}
#endif
