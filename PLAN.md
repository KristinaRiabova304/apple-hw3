# HW3 Student Plan

## Approach

**MVC boundary**

- **Model:** the supplied `Student` struct, `StudentStoreError`, and
  `StudentStore`. The store is the only owner of the student array; all reads
  and mutations (`students`, `students(matchingSubject:)`, `addStudent`,
  `updateStudent`, `deleteStudent`) go through it. `Student` stored properties
  are not changed.
- **Views:** UIKit views laid out with SnapKit only:
  - `StudentCell` — reusable `UITableViewCell` subclass (avatar, name, age,
    average grade, scholarship status), configured from a `Student`.
  - Detail content built from labels in a scroll view, plus one `UIButton` per
    subject.
- **Controllers:**
  - `StudentListViewController` — one class used for both the full list
    (title `Students`) and the subject-filtered list (title = subject).
  - `StudentDetailViewController` — shows every field of one student.
  - `StudentFormViewController` — bonus two-field name/age form used for both
    add and edit.

**One shared `StudentStore`**

`SceneDelegate` creates a single `StudentStore()` and injects it through each
controller's initializer (no singletons, no globals). Controllers never keep
their own authoritative copy of the students:

- The list controller derives its rows from the store on every reload
  (`store.students` or `store.students(matchingSubject:)`).
- The detail controller stores only the student's `id` and looks the student up
  in the store whenever it renders, so edits made elsewhere are reflected.
- Lists reload in `viewWillAppear` and immediately after every successful
  mutation, so returning from detail/edit always shows current data.

**Subject filtering and how it is tested**

Each subject on the detail screen is a `UIButton` with identifier
`subjectButton.<subject>`. Tapping it pushes a `StudentListViewController`
whose filter is that exact subject string; rows come from
`store.students(matchingSubject:)`, which uses exact, case-sensitive
`contains`, so store order is preserved. Tests:

- Unit: filtering `"Physics"` returns the expected IDs in seed order;
  `"physics"` (wrong case) and an unknown subject return empty results.
- UI: Ada Lovelace → `subjectButton.Math` shows a list titled `Math` with only
  the Math students' cells.

**UI / accessibility decisions**

- Accessibility identifiers: `studentList` (table view),
  `studentCell.<student-id>` (cells), `studentDetails` (detail root view),
  `subjectButton.<subject>`, and bonus `addStudentButton` /
  `editStudentButton`; form fields get `nameField`, `ageField`.
- All text uses `UIFont.preferredFont(forTextStyle:)` with
  `adjustsFontForContentSizeCategory = true`; labels use `numberOfLines = 0`
  and the table uses automatic row heights so large Dynamic Type sizes wrap
  instead of truncating.
- Cells expose one combined accessibility label (for example "Ada Lovelace,
  age 20, average grade 97.5, scholarship holder"); avatars are decorative.
- Scholarship status is shown as text (not color alone).
- No force unwraps on user input: the age field is parsed with `Int(_:)` and
  validated, and invalid input shows an alert instead of crashing.
- Navigation uses one `UINavigationController` with standard push/back.

**Bonus: add / edit / delete**

- `+` bar button (`addStudentButton`) on the `Students` list presents the
  form; Save calls `store.addStudent(name:age:)`.
- `Edit` bar button (`editStudentButton`) on the detail screen presents the
  same form prefilled; Save calls `store.updateStudent(id:name:age:)`.
- Swipe-to-delete on list rows calls `store.deleteStudent(id:)`, then the row
  is removed from the table.
- Store errors (`blankName`, `nonPositiveAge`, `unknownID`) show an alert and
  leave the state unchanged; the form is dismissed only on success.
- Visible state refreshes after every successful mutation (list reload, detail
  re-render).

## Milestones

- [x] Student list and reusable cell
- [x] Detail screen and navigation
- [x] Subject-filtered list
- [x] Unit and UI tests
- [x] Optional add/edit/delete bonus, if attempted
- [ ] Local verification and CI review
- [ ] Final diff and evidence review

## Verification plan

Focused tests during development:

```bash
# Unit tests only
xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:StudentDirectoryTests test

# UI tests only
xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:StudentDirectoryUITests test
```

Planned student-authored tests (at least six, beyond the unchanged starter
tests):

1. Subject filter is exact, case-sensitive, and preserves store order.
2. `addStudent` appends a student with grade 0, no scholarship, no subjects,
   and `avatar-default`; blank names and `age <= 0` are rejected without
   mutating state.
3. `updateStudent` changes only name/age; invalid input and unknown IDs do not
   mutate state.
4. `deleteStudent` removes the student; an unknown ID throws and does not
   mutate state.
5. `StudentCell` configuration shows the student's name, age, grade, and
   scholarship status and sets the `studentCell.<id>` identifier.
6. UI: list titled `Students` shows the student cells; tapping a cell opens
   `studentDetails`; back returns to the list.
7. UI: tapping a subject button opens the filtered list with the subject as
   title and only matching students.
8. UI (bonus): add a student through the form and see it in the list; invalid
   input shows an error.

Tests use no network, time, randomness, sleeps, or polling; UI tests use
`waitForExistence` only on deterministic elements, and every launch starts from
the deterministic seed data.

Final command (exactly as in the README):

```bash
xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory -destination 'platform=iOS Simulator,name=iPhone 17' test
```
