import XCTest

final class StudentNavigationUITests: XCTestCase {
    private var app: XCUIApplication!

    private func cellID(_ suffix: Int) -> String {
        "studentCell.00000000-0000-0000-0000-\(String(format: "%012d", suffix))"
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func tapWhenReady(_ element: XCUIElement) {
        XCTAssertTrue(element.waitForExistence(timeout: 10), "\(element) did not appear")
        element.tap()
    }

    func testStudentListShowsTitleAndStudentCells() {
        XCTAssertTrue(app.navigationBars["Students"].waitForExistence(timeout: 10))
        let list = app.tables["studentList"]
        XCTAssertTrue(list.cells[cellID(1)].waitForExistence(timeout: 10))
        XCTAssertTrue(list.cells[cellID(2)].exists)
        XCTAssertTrue(list.cells[cellID(1)].label.contains("Ada Lovelace"))
    }

    func testTappingStudentShowsDetailsAndBackReturnsToList() {
        tapWhenReady(app.tables["studentList"].cells[cellID(1)])

        let details = app.descendants(matching: .any)["studentDetails"]
        XCTAssertTrue(details.waitForExistence(timeout: 5))
        XCTAssertEqual(details.descendants(matching: .any)["detail.name"].value as? String, "Ada Lovelace")
        XCTAssertEqual(details.descendants(matching: .any)["detail.age"].value as? String, "20")
        XCTAssertTrue(app.buttons["subjectButton.Algorithms"].exists)

        app.navigationBars.buttons["BackButton"].tap()

        XCTAssertTrue(app.navigationBars["Students"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.tables["studentList"].cells[cellID(1)].exists)
    }

    func testTappingSubjectShowsOnlyMatchingStudentsInStoreOrder() {
        tapWhenReady(app.tables["studentList"].cells[cellID(1)])
        tapWhenReady(app.buttons["subjectButton.Math"])

        XCTAssertTrue(app.navigationBars["Math"].waitForExistence(timeout: 5))
        let cells = app.tables["studentList"].cells
        XCTAssertEqual(cells.count, 3)
        XCTAssertEqual(cells.element(boundBy: 0).identifier, cellID(1))
        XCTAssertEqual(cells.element(boundBy: 1).identifier, cellID(4))
        XCTAssertEqual(cells.element(boundBy: 2).identifier, cellID(7))
    }
}
