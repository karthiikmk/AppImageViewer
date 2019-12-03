import XCTest
@testable import AppImageViewer

final class AppImageViewerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AppImageViewer().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
