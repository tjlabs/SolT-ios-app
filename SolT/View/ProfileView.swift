import UIKit
import RxSwift
import RxCocoa

class ProfileView: UIView {
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var topView = TopView(title: titleText)
    private lazy var profileUserInfoView = ProfileUserInfoView()
    private lazy var profileBirthView = ProfileBirthView()
    private lazy var profileAllergyView = ProfileAllergyView()
    private let disposeBag = DisposeBag()
    
    var titleText: String = "Default Title"
    var onBackButtonTapped: (() -> Void)?
    
    init(title: String) {
        self.titleText = title
        super.init(frame: .zero)
        setupLayout()
        bindActions()
        setupKeyboardDismissal()
        setupSwipeGesture()
    }
    
    deinit {
        dismissKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindActions() {
        topView.backButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.onBackButtonTapped?()
            }).disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(topView)
        topView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(50)
        }
        
        addSubview(profileUserInfoView)
        profileUserInfoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(topView.snp.bottom)
        }
        
        addSubview(profileBirthView)
        profileBirthView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(profileUserInfoView.snp.bottom).offset(10)
        }
        
        addSubview(profileAllergyView)
        profileAllergyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(profileBirthView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    private func setupSwipeGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGesture)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        if gesture.state == .ended {
            if translation.x > SWIPE_THRESHOLD && abs(translation.y) < 50 {
                onBackButtonTapped?()
            }
        }
    }
}
