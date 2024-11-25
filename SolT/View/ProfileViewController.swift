
import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    static let identifier = "ProfileViewController"
    
    private lazy var topView = TopView(title: titleText)
    var titleText: String = "Default Title"
    private let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindActions()
    }
    
    private func bindActions() {
        topView.backButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.tapBackButton()
            }).disposed(by: disposeBag)
    }
        
    private func tapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

}

private extension ProfileViewController {
    func setupLayout() {
        view.addSubview(topView)
        
        topView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(50)
        }
    }
}
