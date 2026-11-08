import XCTest
@testable import StudentDirectory

final class StarterStudentDirectoryTests: XCTestCase {
    func testStarterStoreIsConstructible() {
        XCTAssertEqual(StudentStore().students.count, 10)
    }

    func testStarterSeedDataHasOverlappingSubjects() {
        let counts = StudentSeedData.students.flatMap(\.subjects).reduce(into: [:]) { counts, subject in
            counts[subject, default: 0] += 1
        }
        XCTAssertTrue(counts.values.contains(where: { $0 > 1 }))
    }
}
