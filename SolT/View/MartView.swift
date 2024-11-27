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
    
    
    private let cartImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "icon_cart")
    }
    
    private let cartCountView: UIView = {
        let view = UIView()
        view.backgroundColor = SOLT_COLOR
        view.layer.cornerRadius = 12.5
        view.isHidden = true
        return view
    }()
    
    private let cartCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.pretendardBold(size: 12)
        label.textAlignment = .center
        return label
    }()
    
    var titleText: String = "Default Title"
    var onBackButtonTapped: (() -> Void)?
    
    init(title: String) {
        self.titleText = title
        super.init(frame: .zero)
        setupLayout()
        bindActions()
        observeCartProducts()
        setupSwipeGesture()
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
        
        addSubview(cartImageView)
        cartImageView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.centerY.equalTo(topView)
            make.trailing.equalToSuperview().inset(30)
        }
        
        addSubview(cartCountView)
        cartCountView.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.top.equalTo(cartImageView.snp.top).offset(-5)
            make.trailing.equalTo(cartImageView.snp.trailing).offset(5)
        }
                
        cartCountView.addSubview(cartCountLabel)
        cartCountLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    private func observeCartProducts() {
    Observable<Int>.create { observer in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                observer.onNext(MartProductView.cartProducts.count)
            }
            return Disposables.create()
        }
        .subscribe(onNext: { [weak self] count in
            self?.updateCartCount(count)
        })
        .disposed(by: disposeBag)
    }
        
    private func updateCartCount(_ count: Int) {
        if count > 0 {
            cartCountLabel.text = "\(count)"
            cartCountView.isHidden = false
        } else {
            cartCountView.isHidden = true
        }
    }
    
    func updateProducts(_ outputProduct: OutputProduct) {
        martProductView.updateProducts(with: outputProduct.product_list)
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
