# Submission

Submit exactly these two values through the course channel:

```text
Public repository URL: https://github.com/<account>/<repository>
Commit SHA: <full 40-character SHA>
```

The submitted commit must be public and contain the implementation, at least
six distinct student-authored XCTest methods, completed `PLAN.md` and
`AGENT_WORKLOG.md`, and any selected non-sensitive artifacts.

Before submitting, run:

```bash
xcodebuild -project StudentDirectory.xcodeproj -scheme StudentDirectory -destination 'platform=iOS Simulator,name=iPhone 17' test
```

Then commit all intended files and verify the submitted SHA with:

```bash
git rev-parse HEAD
```
