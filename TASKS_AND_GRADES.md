# Homework 3 — Tasks and Grades

The base assignment is worth 12 points. The optional mutation extension is
worth up to 4 bonus points. Private checks may vary values and combine
published cases, but may not introduce an unpublished behavioral requirement.

## Supplied model

Do not change the stored properties or names:

```swift
struct Student: Equatable {
    let id: UUID
    var name: String
    var age: Int
    let averageGrade: Double
    let isScholarshipHolder: Bool
    let subjects: [String]
    let avatarName: String
}
```

The starter supplies exactly ten deterministic students with overlapping
subjects and bundled avatar assets. Do not use network calls or random data.

## Required base behavior

1. **Student list — 3 points.** Use UIKit and SnapKit. Display all students in
   a reusable table-view cell with avatar, name, age, average grade, and
   scholarship status. The navigation title is `Students`.
2. **Details and navigation — 2 points.** Tapping a row pushes a detail screen
   showing every student field. Use a navigation controller and standard back
   behavior.
3. **Subject filtering — 2 points.** Each subject is interactive. Tapping it
   pushes a list containing only students whose `subjects` contains the exact,
   case-sensitive subject. Preserve store order and use the subject as title.
4. **UIKit/MVC/SnapKit/accessibility — 3 points.** Keep one shared
   `StudentStore`, avoid duplicated authoritative arrays, use SnapKit layouts,
   meaningful labels/identifiers, Dynamic Type-compatible text, and no
   force-unwrapped user input.
5. **Tests and reproducibility — 1 point.** Add at least six meaningful
   student-authored XCTest methods, including model/store and UI coverage, and
   document a reproducible `xcodebuild test` run.
6. **Evidence and hygiene — 1 point.** Complete `PLAN.md` and
   `AGENT_WORKLOG.md`, disclose tools, review generated changes, and keep the
   repository free of secrets/build output.

Required accessibility identifiers are `studentList`,
`studentCell.<student-id>`, `studentDetails`, and
`subjectButton.<subject>`. Bonus controls use `addStudentButton` and
`editStudentButton`.

## Optional bonus — up to 4 points

Implement the following on the shared store and in the UI:

```swift
func addStudent(name: String, age: Int) throws
func updateStudent(id: UUID, name: String, age: Int) throws
func deleteStudent(id: UUID) throws
```

- Add with a two-field name/age form and reject blank names or `age <= 0` (1).
- Edit only name and age with the same validation (1).
- Swipe to delete a student from the shared store (1).
- Add meaningful tests and refresh visible state after every successful
  mutation (1).

New students use a new UUID, grade `0`, scholarship `false`, empty subjects,
and the bundled default avatar. Invalid input and unknown IDs must not mutate
state. Bonus work cannot reduce the base score.

## Test restrictions

Tests must not rely on network access, current time, random values, sleeps,
polling, or elapsed-time thresholds. Do not change supplied starter tests to
make them pass.

## Submission

Submit exactly:

```text
Public repository URL: https://github.com/<account>/<repository>
Commit SHA: <full 40-character SHA>
```
