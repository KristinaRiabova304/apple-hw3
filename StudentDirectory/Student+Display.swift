import Foundation

/// Display text shared by the list cell and the detail screen.
extension Student {
    var ageText: String { "Age \(age)" }

    var averageGradeText: String { "Grade \(String(format: "%.1f", averageGrade))" }

    var scholarshipText: String { isScholarshipHolder ? "Scholarship holder" : "No scholarship" }
}
