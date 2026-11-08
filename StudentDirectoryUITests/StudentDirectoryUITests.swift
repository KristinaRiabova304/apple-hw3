import XCTest

final class StudentDirectoryUITests: XCTestCase {
    func testStarterApplicationLaunches() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))
    }
}
