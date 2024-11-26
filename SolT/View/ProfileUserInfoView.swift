import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class ProfileUserInfoView: UIView {
    let VIEW_BORDER_WIDTH: CGFloat = 4
    let VIEW_CORNER_RADIUS: CGFloat = 10

    private static var selectedGender: Gender = .male
    private static var selectedVeganStatus: VeganStatus = .nonVegan
    
    enum Gender {
        case male
        case female
    }
    
    enum VeganStatus {
        case vegan
        case nonVegan
    }
    
    private let stackViewForContents: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    private let stackViewForGender: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var maleContainerView = createContainerView()
    private lazy var femaleContainerView = createContainerView()
    private lazy var maleView = createSelectableView()
    private lazy var femaleView = createSelectableView()
    private lazy var maleImageView = createImageView(named: "icon_male_select")
    private lazy var femaleImageView = createImageView(named: "icon_female_deselect")
    private lazy var maleLabel: UILabel = createLabel(with: "Male")
    private lazy var femaleLabel: UILabel = createLabel(with: "Female")
    
    private let stackViewForVegan: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var veganContainerView = createContainerView()
    private lazy var nonveganContainerView = createContainerView()
    private lazy var veganView = createSelectableView()
    private lazy var nonveganView = createSelectableView()
    private lazy var veganImageView = createImageView(named: "icon_vegan_deselect")
    private lazy var nonveganImageView = createImageView(named: "icon_nonvegan_select")
    private lazy var veganLabel: UILabel = createLabel(with: "VEGAN")
    private lazy var nonveganLabel: UILabel = createLabel(with: "NON-VEG")
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setupLayout()
        addTouchHandlers()
        applySavedSelections()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(112)
        }
        
        addSubview(stackViewForContents)
        stackViewForContents.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        stackViewForContents.addArrangedSubview(stackViewForGender)
        stackViewForContents.addArrangedSubview(stackViewForVegan)
        
        setupGenderViews()
        setupVeganViews()
        
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupGenderViews() {
        stackViewForGender.addArrangedSubview(maleContainerView)
        stackViewForGender.addArrangedSubview(femaleContainerView)
        
        setupContainer(maleContainerView, view: maleView, label: maleLabel, imageView: maleImageView, insetValues: 10)
        setupContainer(femaleContainerView, view: femaleView, label: femaleLabel, imageView: femaleImageView, insetValues: 10)
    }
    
    private func setupVeganViews() {
        stackViewForVegan.addArrangedSubview(veganContainerView)
        stackViewForVegan.addArrangedSubview(nonveganContainerView)
        
        setupContainer(veganContainerView, view: veganView, label: veganLabel, imageView: veganImageView, insetValues: 15)
        setupContainer(nonveganContainerView, view: nonveganView, label: nonveganLabel, imageView: nonveganImageView, insetValues: 15)
    }
    
    private func setupContainer(_ container: UIView, view: UIView, label: UILabel, imageView: UIImageView, insetValues: CGFloat) {
        container.addSubview(view)
        container.addSubview(label)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(view.snp.width)
        }
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.snp.bottom).offset(0)
            make.bottom.equalToSuperview().inset(0)
        }
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(insetValues)
        }
    }
    
    // MARK: - Add Touch Handlers
    private func addTouchHandlers() {
        maleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMaleTap)))
        femaleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFemaleTap)))
        veganView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleVeganTap)))
        nonveganView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNonVeganTap)))
    }
    
    // MARK: - Gesture Handlers
    @objc private func handleMaleTap() {
        selectGender(.male)
    }
    
    @objc private func handleFemaleTap() {
        selectGender(.female)
    }
    
    @objc private func handleVeganTap() {
        selectVeganStatus(.vegan)
    }
    
    @objc private func handleNonVeganTap() {
        selectVeganStatus(.nonVegan)
    }
    
    // MARK: - Selection Logic
    private func selectGender(_ gender: Gender) {
        ProfileUserInfoView.selectedGender = gender
        
        maleView.borderColor = gender == .male ? SOLT_COLOR : DESELECT_COLOR
        femaleView.borderColor = gender == .female ? SOLT_COLOR : DESELECT_COLOR
        
        maleImageView.image = UIImage(named: gender == .male ? "icon_male_select" : "icon_male_deselect")
        femaleImageView.image = UIImage(named: gender == .female ? "icon_female_select" : "icon_female_deselect")
    }
    
    private func selectVeganStatus(_ status: VeganStatus) {
        ProfileUserInfoView.selectedVeganStatus = status
        
        veganView.borderColor = status == .vegan ? VEGAN_COLOR : DESELECT_COLOR
        nonveganView.borderColor = status == .nonVegan ? NONVEGAN_COLOR : DESELECT_COLOR
        
        veganImageView.image = UIImage(named: status == .vegan ? "icon_vegan_select" : "icon_vegan_deselect")
        nonveganImageView.image = UIImage(named: status == .nonVegan ? "icon_nonvegan_select" : "icon_nonvegan_deselect")
    }
    
    private func applySavedSelections() {
        selectGender(ProfileUserInfoView.selectedGender)
        selectVeganStatus(ProfileUserInfoView.selectedVeganStatus)
    }
    
    // MARK: - Helper Functions
    private func createContainerView() -> UIView {
        UIView()
    }
    
    private func createSelectableView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = VIEW_BORDER_WIDTH
        view.layer.cornerRadius = VIEW_CORNER_RADIUS
        view.layer.borderColor = DESELECT_COLOR.cgColor
        return view
    }
    
    private func createImageView(named: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: named)
        return imageView
    }
    
    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.pretendardBold(size: 12)
        label.textAlignment = .center
        label.textColor = .black
        label.text = text
        return label
    }
}
