import XCTest

final class StudentMutationUITests: XCTestCase {
    private var app: XCUIApplication!

    private let adaCellID = "studentCell.00000000-0000-0000-0000-000000000001"
    private let alanCellID = "studentCell.00000000-0000-0000-0000-000000000002"
    private let timCellID = "studentCell.00000000-0000-0000-0000-000000000010"

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    private func cells(labelContaining text: String) -> XCUIElementQuery {
        app.tables["studentList"].cells.matching(NSPredicate(format: "label CONTAINS %@", text))
    }

    private func fillForm(name: String, age: String, clearingExisting existingLength: Int = 0) {
        let deletes = String(repeating: XCUIKeyboardKey.delete.rawValue, count: existingLength)
        let nameField = app.textFields["nameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 5))
        nameField.tap()
        nameField.typeText(deletes + name)
        let ageField = app.textFields["ageField"]
        ageField.tap()
        ageField.typeText(deletes + age)
        app.buttons["saveStudentButton"].tap()
    }

    private func tapWhenReady(_ element: XCUIElement) {
        XCTAssertTrue(element.waitForExistence(timeout: 10), "\(element) did not appear")
        element.tap()
    }

    func testAddingStudentShowsNewStudentInList() {
        tapWhenReady(app.buttons["addStudentButton"])

        fillForm(name: "Margaret Hamilton", age: "25")

        let newCell = cells(labelContaining: "Margaret Hamilton").firstMatch
        XCTAssertTrue(newCell.waitForExistence(timeout: 5))
        XCTAssertTrue(newCell.label.contains("Age 25"))
        XCTAssertTrue(newCell.label.contains("No scholarship"))
        XCTAssertFalse(app.textFields["nameField"].exists, "Form should close after a successful save")
    }

    func testAddingInvalidStudentShowsErrorAndDoesNotAddStudent() {
        tapWhenReady(app.buttons["addStudentButton"])

        fillForm(name: "Not Added", age: "0")

        let alert = app.alerts["Invalid student"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        alert.buttons["OK"].tap()
        XCTAssertTrue(app.textFields["nameField"].exists, "Form stays open after invalid input")
        app.buttons["cancelStudentButton"].tap()

        let list = app.tables["studentList"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        list.swipeUp()
        XCTAssertTrue(list.cells[timCellID].exists)
        XCTAssertEqual(cells(labelContaining: "Not Added").count, 0)
    }

    func testEditingStudentUpdatesDetailsAndList() {
        tapWhenReady(app.tables["studentList"].cells[adaCellID])
        tapWhenReady(app.buttons["editStudentButton"])

        fillForm(name: "Ada King", age: "36", clearingExisting: "Ada Lovelace".count)

        let details = app.descendants(matching: .any)["studentDetails"]
        let nameRow = details.descendants(matching: .any)["detail.name"]
        XCTAssertTrue(nameRow.waitForExistence(timeout: 5))
        XCTAssertEqual(nameRow.value as? String, "Ada King")
        XCTAssertEqual(details.descendants(matching: .any)["detail.age"].value as? String, "36")

        app.navigationBars.buttons["BackButton"].tap()

        let adaCell = app.tables["studentList"].cells[adaCellID]
        XCTAssertTrue(adaCell.waitForExistence(timeout: 5))
        XCTAssertTrue(adaCell.label.hasPrefix("Ada King, Age 36"))
    }

    func testSwipeToDeleteRemovesStudentFromList() {
        let adaCell = app.tables["studentList"].cells[adaCellID]
        XCTAssertTrue(adaCell.waitForExistence(timeout: 10))

        // An explicit drag is used instead of swipeLeft(), which a slow simulator can register as a tap.
        let start = adaCell.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
        let end = adaCell.coordinate(withNormalizedOffset: CGVector(dx: 0.2, dy: 0.5))
        start.press(forDuration: 0.1, thenDragTo: end)
        tapWhenReady(app.buttons["Delete"])

        XCTAssertTrue(adaCell.waitForNonExistence(timeout: 5))
        XCTAssertTrue(app.tables["studentList"].cells[alanCellID].exists)
    }
}
