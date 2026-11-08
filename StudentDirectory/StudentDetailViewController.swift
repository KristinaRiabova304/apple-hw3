import SnapKit
import UIKit

/// Shows every field of one student. Only the ID is kept; the student itself is
/// always read from the shared store so the screen never shows stale data.
final class StudentDetailViewController: UIViewController {
    private let store: StudentStore
    private let studentID: UUID

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let avatarImageView = UIImageView()
    private let fieldsStack = UIStackView()
    private let subjectsStack = UIStackView()

    private var student: Student? {
        store.students.first { $0.id == studentID }
    }

    init(store: StudentStore, studentID: UUID) {
        self.store = store
        self.studentID = studentID
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = "studentDetails"
        navigationItem.largeTitleDisplayMode = .never
        let editButton = UIBarButtonItem(systemItem: .edit, primaryAction: UIAction { [weak self] _ in
            self?.presentEditForm()
        })
        editButton.accessibilityIdentifier = "editStudentButton"
        navigationItem.rightBarButtonItem = editButton
        setUpViews()
        render()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        render()
    }

    private func presentEditForm() {
        guard let student else { return }
        let form = StudentFormViewController(title: "Edit Student", name: student.name, age: student.age) { [weak self] name, age in
            guard let self else { return }
            try self.store.updateStudent(id: self.studentID, name: name, age: age)
            self.render()
        }
        present(UINavigationController(rootViewController: form), animated: true)
    }

    private func setUpViews() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 60
        avatarImageView.isAccessibilityElement = false

        fieldsStack.axis = .vertical
        fieldsStack.spacing = 12

        subjectsStack.axis = .vertical
        subjectsStack.alignment = .leading
        subjectsStack.spacing = 8

        let subjectsTitle = makeLabel(text: "Subjects", textStyle: .headline, color: .label)
        subjectsTitle.accessibilityTraits = .header

        // Centered so the avatar sits in the middle; the other rows are pinned to full width below.
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 20
        contentStack.addArrangedSubview(avatarImageView)
        contentStack.addArrangedSubview(fieldsStack)
        contentStack.addArrangedSubview(subjectsTitle)
        contentStack.setCustomSpacing(8, after: subjectsTitle)
        contentStack.addArrangedSubview(subjectsStack)

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentStack.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView.contentLayoutGuide).inset(20)
            make.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(20)
        }
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(120)
        }
        for fullWidthView in [fieldsStack, subjectsTitle, subjectsStack] {
            fullWidthView.snp.makeConstraints { make in
                make.width.equalTo(contentStack)
            }
        }
    }

    private func render() {
        guard let student else {
            // The student no longer exists in the store (e.g. deleted elsewhere).
            navigationController?.popViewController(animated: true)
            return
        }

        title = student.name
        avatarImageView.image = UIImage(named: student.avatarName) ?? UIImage(named: "avatar-default")

        fieldsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let fields: [(title: String, value: String, id: String)] = [
            ("Name", student.name, "name"),
            ("Age", "\(student.age)", "age"),
            ("Average grade", String(format: "%.1f", student.averageGrade), "averageGrade"),
            ("Scholarship", student.isScholarshipHolder ? "Yes" : "No", "scholarship"),
            ("Avatar", student.avatarName, "avatarName"),
            ("ID", student.id.uuidString, "id")
        ]
        for field in fields {
            fieldsStack.addArrangedSubview(makeFieldRow(title: field.title, value: field.value, identifier: field.id))
        }

        subjectsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if student.subjects.isEmpty {
            subjectsStack.addArrangedSubview(makeLabel(text: "No subjects", textStyle: .body, color: .secondaryLabel))
        }
        for subject in student.subjects {
            subjectsStack.addArrangedSubview(makeSubjectButton(subject: subject))
        }
    }

    private func makeFieldRow(title: String, value: String, identifier: String) -> UIView {
        let titleLabel = makeLabel(text: title, textStyle: .caption1, color: .secondaryLabel)
        let valueLabel = makeLabel(text: value, textStyle: .body, color: .label)
        let row = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        row.axis = .vertical
        row.spacing = 2
        row.isAccessibilityElement = true
        row.accessibilityLabel = title
        row.accessibilityValue = value
        row.accessibilityIdentifier = "detail.\(identifier)"
        return row
    }

    private func makeSubjectButton(subject: String) -> UIButton {
        var configuration = UIButton.Configuration.tinted()
        configuration.title = subject
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = .preferredFont(forTextStyle: .body)
            return attributes
        }
        let button = UIButton(configuration: configuration)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.accessibilityIdentifier = "subjectButton.\(subject)"
        button.accessibilityHint = "Shows students taking \(subject)"
        button.addAction(UIAction { [weak self] _ in
            self?.showStudents(takingSubject: subject)
        }, for: .primaryActionTriggered)
        return button
    }

    private func showStudents(takingSubject subject: String) {
        let filteredList = StudentListViewController(store: store, subject: subject)
        navigationController?.pushViewController(filteredList, animated: true)
    }

    private func makeLabel(text: String, textStyle: UIFont.TextStyle, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: textStyle)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textColor = color
        return label
    }
}
