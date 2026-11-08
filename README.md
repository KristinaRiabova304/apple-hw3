# Homework 3 — UIKit Student Directory

Build an iOS UIKit application with SnapKit using the supplied `Student` model
and deterministic seed data. This homework is individual work.

Read [`TASKS_AND_GRADES.md`](TASKS_AND_GRADES.md) before changing the starter.
The required design is MVC; MVVM and coordinators belong to HW4. SwiftLint is
not required.

## Required verification

```bash
xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory -destination 'platform=iOS Simulator,name=iPhone 17' test
```

The same test intent runs in GitHub Actions. Record the actual local and CI
results in `AGENT_WORKLOG.md`; a local pass is not evidence that CI passed.

## Start here

1. Read `TASKS_AND_GRADES.md`.
2. Complete `PLAN.md` before implementation.
3. Build the three required UIKit flows: list, detail, and subject filter.
4. Add at least six meaningful student-authored XCTest methods beyond the
   unchanged starter tests.
5. Keep `AGENT_WORKLOG.md` current and review every agent-generated change.
6. Run the exact verification command above before submission.
7. Submit the public repository URL and full 40-character commit SHA as
   described in `SUBMISSION.md`.

The optional add/edit/delete extension is worth up to four bonus points and
cannot reduce the twelve-point base score.
