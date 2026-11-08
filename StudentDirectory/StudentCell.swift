import SnapKit
import UIKit

final class StudentCell: UITableViewCell {
    static let reuseIdentifier = "StudentCell"

    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ageAndGradeLabel = UILabel()
    private let scholarshipLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with student: Student) {
        avatarImageView.image = UIImage(named: student.avatarName) ?? UIImage(named: "avatar-default")
        nameLabel.text = student.name
        ageAndGradeLabel.text = "\(student.ageText) · \(student.averageGradeText)"
        scholarshipLabel.text = student.scholarshipText
        scholarshipLabel.textColor = student.isScholarshipHolder ? .systemGreen : .secondaryLabel

        accessibilityIdentifier = "studentCell.\(student.id.uuidString)"
        accessibilityLabel = [student.name, student.ageText, student.averageGradeText, student.scholarshipText]
            .joined(separator: ", ")
    }

    private func setUpViews() {
        accessoryType = .disclosureIndicator
        isAccessibilityElement = true
        accessibilityTraits = .button

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 28
        avatarImageView.isAccessibilityElement = false

        configure(nameLabel, textStyle: .headline, color: .label)
        configure(ageAndGradeLabel, textStyle: .subheadline, color: .secondaryLabel)
        configure(scholarshipLabel, textStyle: .footnote, color: .secondaryLabel)

        let labelsStack = UIStackView(arrangedSubviews: [nameLabel, ageAndGradeLabel, scholarshipLabel])
        labelsStack.axis = .vertical
        labelsStack.spacing = 2

        contentView.addSubview(avatarImageView)
        contentView.addSubview(labelsStack)

        avatarImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.layoutMarginsGuide)
            make.centerY.equalToSuperview()
            make.top.greaterThanOrEqualTo(contentView.layoutMarginsGuide)
            make.bottom.lessThanOrEqualTo(contentView.layoutMarginsGuide)
            make.size.equalTo(56)
        }
        labelsStack.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.trailing.top.bottom.equalTo(contentView.layoutMarginsGuide)
        }
    }

    private func configure(_ label: UILabel, textStyle: UIFont.TextStyle, color: UIColor) {
        label.font = .preferredFont(forTextStyle: textStyle)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textColor = color
    }
}
