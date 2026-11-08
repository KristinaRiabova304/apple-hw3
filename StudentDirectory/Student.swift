import Foundation

struct Student: Equatable {
    let id: UUID
    var name: String
    var age: Int
    let averageGrade: Double
    let isScholarshipHolder: Bool
    let subjects: [String]
    let avatarName: String
}

enum StudentStoreError: Error, Equatable {
    case blankName
    case nonPositiveAge
    case unknownID(UUID)
}
