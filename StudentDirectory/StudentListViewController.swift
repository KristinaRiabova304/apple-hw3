import SnapKit
import UIKit

/// Shows every student, or only the students taking `subject` when one is given.
final class StudentListViewController: UIViewController {
    private let store: StudentStore
    private let subject: String?
    private let tableView = UITableView(frame: .zero, style: .plain)

    /// Rows are always derived from the shared store; no copy is kept here.
    private var displayedStudents: [Student] {
        guard let subject else { return store.students }
        return store.students(matchingSubject: subject)
    }

    init(store: StudentStore, subject: String? = nil) {
        self.store = store
        self.subject = subject
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = subject ?? "Students"
        view.backgroundColor = .systemBackground

        tableView.accessibilityIdentifier = "studentList"
        tableView.register(StudentCell.self, forCellReuseIdentifier: StudentCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // New students have no subjects, so adding only makes sense on the full list.
        if subject == nil {
            let addButton = UIBarButtonItem(systemItem: .add, primaryAction: UIAction { [weak self] _ in
                self?.presentAddForm()
            })
            addButton.accessibilityIdentifier = "addStudentButton"
            addButton.accessibilityLabel = "Add student"
            navigationItem.rightBarButtonItem = addButton
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    private func presentAddForm() {
        let form = StudentFormViewController(title: "New Student") { [weak self] name, age in
            guard let self else { return }
            try self.store.addStudent(name: name, age: age)
            self.tableView.reloadData()
            let lastRow = self.displayedStudents.count - 1
            if lastRow >= 0 {
                self.tableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom, animated: false)
            }
        }
        present(UINavigationController(rootViewController: form), animated: true)
    }

    private func deleteStudent(at indexPath: IndexPath) {
        let student = displayedStudents[indexPath.row]
        do {
            try store.deleteStudent(id: student.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            tableView.reloadData()
            let message = (error as? StudentStoreError)?.message ?? error.localizedDescription
            let alert = UIAlertController(title: "Could not delete", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

extension StudentListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedStudents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentCell.reuseIdentifier, for: indexPath)
        if let studentCell = cell as? StudentCell {
            studentCell.configure(with: displayedStudents[indexPath.row])
        }
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else { return }
        deleteStudent(at: indexPath)
    }
}

extension StudentListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let student = displayedStudents[indexPath.row]
        let detailController = StudentDetailViewController(store: store, studentID: student.id)
        navigationController?.pushViewController(detailController, animated: true)
    }
}
