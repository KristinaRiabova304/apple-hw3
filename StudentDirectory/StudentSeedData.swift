import Foundation

enum StudentSeedData {
    static let students: [Student] = [
        Student(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, name: "Ada Lovelace", age: 20, averageGrade: 97.5, isScholarshipHolder: true, subjects: ["Algorithms", "Math", "Design"], avatarName: "avatar-01"),
        Student(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, name: "Alan Turing", age: 21, averageGrade: 94.0, isScholarshipHolder: true, subjects: ["Algorithms", "Physics"], avatarName: "avatar-02"),
        Student(id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!, name: "Grace Hopper", age: 22, averageGrade: 91.5, isScholarshipHolder: false, subjects: ["Programming", "Algorithms"], avatarName: "avatar-03"),
        Student(id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!, name: "Katherine Johnson", age: 20, averageGrade: 99.0, isScholarshipHolder: true, subjects: ["Math", "Physics"], avatarName: "avatar-04"),
        Student(id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!, name: "Edsger Dijkstra", age: 23, averageGrade: 88.5, isScholarshipHolder: false, subjects: ["Algorithms", "Programming"], avatarName: "avatar-05"),
        Student(id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!, name: "Mary Jackson", age: 21, averageGrade: 93.0, isScholarshipHolder: true, subjects: ["Physics", "Design"], avatarName: "avatar-06"),
        Student(id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!, name: "Donald Knuth", age: 24, averageGrade: 86.0, isScholarshipHolder: false, subjects: ["Algorithms", "Math"], avatarName: "avatar-07"),
        Student(id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!, name: "Hedy Lamarr", age: 22, averageGrade: 90.0, isScholarshipHolder: false, subjects: ["Design", "Programming"], avatarName: "avatar-08"),
        Student(id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!, name: "Barbara Liskov", age: 23, averageGrade: 96.0, isScholarshipHolder: true, subjects: ["Programming", "Design"], avatarName: "avatar-09"),
        Student(id: UUID(uuidString: "00000000-0000-0000-0000-000000000010")!, name: "Tim Berners-Lee", age: 21, averageGrade: 89.5, isScholarshipHolder: false, subjects: ["Programming", "Physics"], avatarName: "avatar-10")
    ]
}
