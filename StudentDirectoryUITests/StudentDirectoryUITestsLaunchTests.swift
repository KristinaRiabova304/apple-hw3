import XCTest

final class StudentDirectoryUITestsLaunchTests: XCTestCase {
    func testStarterLaunchInterface() {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 10))
    }
}
