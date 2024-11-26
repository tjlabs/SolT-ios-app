import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MartView: UIView {
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var topView = TopView(title: titleText)
    private let martAdView = MartAdView()
    private let martCategoryView = MartCategoryView()
    private let martProductView = MartProductView()
    private let disposeBag = DisposeBag()
    
    var titleText: String = "Default Title"
    var onBackButtonTapped: (() -> Void)?
    
    init(title: String) {
        self.titleText = title
        super.init(frame: .zero)
        setupLayout()
        bindActions()
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
        // Add the background view
        addSubview(backgroundView)
        
        // Layout the background view to fill the entire MapView
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Add the topView on top of the backgroundView
        addSubview(topView)
        topView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(50)
        }
        
        addSubview(martAdView)
        martAdView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview()
        }
        
        addSubview(martCategoryView)
        martCategoryView.snp.makeConstraints { make in
            make.top.equalTo(martAdView.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        addSubview(martProductView)
        martProductView.snp.makeConstraints { make in
            make.top.equalTo(martCategoryView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func updateProducts(_ outputProduct: OutputProduct) {
        martProductView.updateProducts(with: outputProduct.product_list) // Pass products to MartProductView.
    }
}
