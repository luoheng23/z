import XCTest
@testable import z

final class zTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(z().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
