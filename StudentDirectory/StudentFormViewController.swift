import SnapKit
import UIKit

/// Two-field name/age form used for both adding and editing a student.
/// The presenting controller performs the store mutation in `onSave`; the form
/// only collects input, shows validation errors, and dismisses on success.
final class StudentFormViewController: UIViewController {
    private let initialName: String
    private let initialAge: Int?
    private let onSave: (_ name: String, _ age: Int) throws -> Void

    private let nameField = UITextField()
    private let ageField = UITextField()

    init(title: String, name: String = "", age: Int? = nil, onSave: @escaping (_ name: String, _ age: Int) throws -> Void) {
        self.initialName = name
        self.initialAge = age
        self.onSave = onSave
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.accessibilityIdentifier = "studentForm"

        let cancelButton = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        })
        cancelButton.accessibilityIdentifier = "cancelStudentButton"
        let saveButton = UIBarButtonItem(systemItem: .save, primaryAction: UIAction { [weak self] _ in
            self?.save()
        })
        saveButton.accessibilityIdentifier = "saveStudentButton"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton

        configure(nameField, placeholder: "Name", identifier: "nameField")
        nameField.text = initialName
        nameField.textContentType = .name
        nameField.autocapitalizationType = .words
        nameField.returnKeyType = .next
        nameField.addAction(UIAction { [weak self] _ in
            self?.ageField.becomeFirstResponder()
        }, for: .editingDidEndOnExit)

        configure(ageField, placeholder: "Age", identifier: "ageField")
        ageField.text = initialAge.map(String.init)
        ageField.keyboardType = .numberPad

        let stack = UIStackView(arrangedSubviews: [
            makeCaption("Name"), nameField,
            makeCaption("Age"), ageField
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.setCustomSpacing(20, after: nameField)

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameField.becomeFirstResponder()
    }

    private func save() {
        let name = nameField.text ?? ""
        let ageText = (ageField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard let age = Int(ageText) else {
            showError(message: "Enter the age as a whole number.")
            return
        }
        do {
            try onSave(name, age)
            dismiss(animated: true)
        } catch {
            showError(message: (error as? StudentStoreError)?.message ?? error.localizedDescription)
        }
    }

    private func showError(message: String) {
        let alert = UIAlertController(title: "Invalid student", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func configure(_ field: UITextField, placeholder: String, identifier: String) {
        field.placeholder = placeholder
        field.accessibilityLabel = placeholder
        field.accessibilityIdentifier = identifier
        field.borderStyle = .roundedRect
        field.font = .preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        field.clearButtonMode = .whileEditing
    }

    private func makeCaption(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.isAccessibilityElement = false
        return label
    }
}

extension StudentStoreError {
    var message: String {
        switch self {
        case .blankName:
            return "The name cannot be blank."
        case .nonPositiveAge:
            return "The age must be greater than zero."
        case .unknownID:
            return "This student no longer exists."
        }
    }
}
