import Foundation
import UIKit

class ProfileBirthView: UIView {
    let VIEW_BORDER_WIDTH: CGFloat = 2
    let VIEW_CORNER_RADIUS: CGFloat = 6
    
    // Static properties to save and restore input values
    private static var savedYear: String = ""
    private static var savedMonth: String = ""
    private static var savedDay: String = ""
    
    private lazy var titleLabel: UILabel = createLabel(with: "Birth")
    private let stackViewForBirth: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var yearTextField = createStyledTextField(placeholder: "Year")
    private lazy var monthTextField = createStyledTextField(placeholder: "Month")
    private lazy var dayTextField = createStyledTextField(placeholder: "Day")
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setupLayout()
        applySavedValues()
        addTouchHandlers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        // Add title label
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(0)
        }
        
        // Add stackViewForBirth
        addSubview(stackViewForBirth)
        stackViewForBirth.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        // Add textFields to stackViewForBirth
        stackViewForBirth.addArrangedSubview(yearTextField)
        stackViewForBirth.addArrangedSubview(monthTextField)
        stackViewForBirth.addArrangedSubview(dayTextField)
        
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Add Touch Handlers
    private func addTouchHandlers() {
        yearTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        monthTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        dayTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField == yearTextField {
            ProfileBirthView.savedYear = textField.text ?? ""
        } else if textField == monthTextField {
            ProfileBirthView.savedMonth = textField.text ?? ""
        } else if textField == dayTextField {
            ProfileBirthView.savedDay = textField.text ?? ""
        }
    }
    
    // MARK: - Apply Saved Values
    private func applySavedValues() {
        yearTextField.text = ProfileBirthView.savedYear
        monthTextField.text = ProfileBirthView.savedMonth
        dayTextField.text = ProfileBirthView.savedDay
    }
    
    // MARK: - Helper Methods
    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.pretendardBold(size: 20)
        label.textAlignment = .left
        label.textColor = .black
        label.text = text
        return label
    }
    
    private func createStyledTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont.pretendardBold(size: 18)
        textField.textAlignment = .left
        textField.textColor = .black
        textField.layer.borderWidth = VIEW_BORDER_WIDTH
        textField.layer.cornerRadius = VIEW_CORNER_RADIUS
        textField.layer.borderColor = SOLT_COLOR.cgColor
        textField.addLeftPadding()
        
        return textField
    }
}
