import UIKit
import XCTest
@testable import StudentDirectory

@MainActor
final class StudentStoreTests: XCTestCase {
    private func id(_ suffix: Int) -> UUID {
        UUID(uuidString: String(format: "00000000-0000-0000-0000-%012d", suffix)) ?? UUID()
    }

    // MARK: - Subject filtering

    func testSubjectFilterIsExactCaseSensitiveAndPreservesStoreOrder() {
        let store = StudentStore()

        XCTAssertEqual(store.students(matchingSubject: "Physics").map(\.id), [id(2), id(4), id(6), id(10)])
        XCTAssertEqual(store.students(matchingSubject: "Math").map(\.name), ["Ada Lovelace", "Katherine Johnson", "Donald Knuth"])
        XCTAssertTrue(store.students(matchingSubject: "physics").isEmpty, "Matching must be case-sensitive")
        XCTAssertTrue(store.students(matchingSubject: "Phys").isEmpty, "Matching must be exact, not a prefix")
        XCTAssertTrue(store.students(matchingSubject: "Chemistry").isEmpty)
    }

    func testFilteredListControllerShowsSubjectTitleAndOnlyMatchingRows() throws {
        let store = StudentStore()
        let controller = StudentListViewController(store: store, subject: "Design")
        controller.loadViewIfNeeded()

        let tableView = try XCTUnwrap(controller.view.subviews.compactMap { $0 as? UITableView }.first)
        XCTAssertEqual(controller.title, "Design")
        XCTAssertEqual(tableView.accessibilityIdentifier, "studentList")
        XCTAssertEqual(controller.tableView(tableView, numberOfRowsInSection: 0), store.students(matchingSubject: "Design").count)

        let firstCell = controller.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        XCTAssertEqual(firstCell.accessibilityIdentifier, "studentCell.\(id(1).uuidString)")
    }

    // MARK: - Cell

    func testStudentCellShowsAllListFieldsAndIdentifier() {
        let student = StudentSeedData.students[0]
        let cell = StudentCell(style: .default, reuseIdentifier: StudentCell.reuseIdentifier)

        cell.configure(with: student)

        XCTAssertEqual(cell.accessibilityIdentifier, "studentCell.\(student.id.uuidString)")
        XCTAssertEqual(cell.accessibilityLabel, "Ada Lovelace, Age 20, Grade 97.5, Scholarship holder")

        let nonHolder = StudentSeedData.students[2]
        cell.configure(with: nonHolder)
        XCTAssertEqual(cell.accessibilityLabel, "Grace Hopper, Age 22, Grade 91.5, No scholarship")
    }

    // MARK: - Add

    func testAddStudentAppendsStudentWithRequiredDefaults() throws {
        let store = StudentStore()

        try store.addStudent(name: "Margaret Hamilton", age: 25)

        XCTAssertEqual(store.students.count, 11)
        let added = try XCTUnwrap(store.students.last)
        XCTAssertEqual(added.name, "Margaret Hamilton")
        XCTAssertEqual(added.age, 25)
        XCTAssertEqual(added.averageGrade, 0)
        XCTAssertFalse(added.isScholarshipHolder)
        XCTAssertEqual(added.subjects, [])
        XCTAssertEqual(added.avatarName, "avatar-default")
        XCTAssertFalse(StudentSeedData.students.map(\.id).contains(added.id), "New students need a new UUID")
    }

    func testAddStudentRejectsInvalidInputWithoutMutatingState() {
        let store = StudentStore()
        let before = store.students

        XCTAssertThrowsError(try store.addStudent(name: "   ", age: 20)) { error in
            XCTAssertEqual(error as? StudentStoreError, .blankName)
        }
        XCTAssertThrowsError(try store.addStudent(name: "Valid Name", age: 0)) { error in
            XCTAssertEqual(error as? StudentStoreError, .nonPositiveAge)
        }
        XCTAssertThrowsError(try store.addStudent(name: "Valid Name", age: -3))
        XCTAssertEqual(store.students, before)
    }

    // MARK: - Update

    func testUpdateStudentChangesOnlyNameAndAge() throws {
        let store = StudentStore()
        let original = store.students[3]

        try store.updateStudent(id: original.id, name: "Katherine G. Johnson", age: 30)

        let updated = store.students[3]
        XCTAssertEqual(updated.id, original.id)
        XCTAssertEqual(updated.name, "Katherine G. Johnson")
        XCTAssertEqual(updated.age, 30)
        XCTAssertEqual(updated.averageGrade, original.averageGrade)
        XCTAssertEqual(updated.isScholarshipHolder, original.isScholarshipHolder)
        XCTAssertEqual(updated.subjects, original.subjects)
        XCTAssertEqual(updated.avatarName, original.avatarName)
        XCTAssertEqual(Array(store.students.prefix(3)), Array(StudentSeedData.students.prefix(3)))
    }

    func testUpdateStudentRejectsInvalidInputAndUnknownIDWithoutMutatingState() {
        let store = StudentStore()
        let before = store.students
        let unknownID = id(999)

        XCTAssertThrowsError(try store.updateStudent(id: id(1), name: "", age: 20)) { error in
            XCTAssertEqual(error as? StudentStoreError, .blankName)
        }
        XCTAssertThrowsError(try store.updateStudent(id: id(1), name: "Ada", age: 0)) { error in
            XCTAssertEqual(error as? StudentStoreError, .nonPositiveAge)
        }
        XCTAssertThrowsError(try store.updateStudent(id: unknownID, name: "Nobody", age: 20)) { error in
            XCTAssertEqual(error as? StudentStoreError, .unknownID(unknownID))
        }
        XCTAssertEqual(store.students, before)
    }

    // MARK: - Delete

    func testDeleteStudentRemovesOnlyThatStudentAndRejectsUnknownID() throws {
        let store = StudentStore()

        try store.deleteStudent(id: id(2))

        XCTAssertEqual(store.students.count, 9)
        XCTAssertFalse(store.students.contains { $0.id == id(2) })
        XCTAssertEqual(store.students(matchingSubject: "Physics").map(\.id), [id(4), id(6), id(10)])

        let afterDelete = store.students
        let unknownID = id(999)
        XCTAssertThrowsError(try store.deleteStudent(id: unknownID)) { error in
            XCTAssertEqual(error as? StudentStoreError, .unknownID(unknownID))
        }
        XCTAssertEqual(store.students, afterDelete)
    }
}
