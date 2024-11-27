import UIKit
import RxSwift
import RxCocoa

class CartView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CartProductCellDelegate {
    private let disposeBag = DisposeBag()
    private var sortedCartProducts: [Product] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CartProductCell.self, forCellWithReuseIdentifier: CartProductCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var topView = TopView(title: titleText)
    private let noItemLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no item in cart"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.pretendardBold(size: 20)
        return label
    }()
    
    // Check Out
    private lazy var checkOutView: UIView = {
        let view = UIView()
        view.backgroundColor = SOLT_COLOR
        view.isHidden = true
        return view
    }()
    
    private let totalItemsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.pretendardBold(size: 14)
        return label
    }()

    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.pretendardBold(size: 14)
        return label
    }()
    
    private let checkOutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Check out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.pretendardExtraBold(size: 22)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(checkOutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var titleText: String = "Default Title"
    var onBackButtonTapped: (() -> Void)?
    
    init(title: String) {
        self.titleText = title
        super.init(frame: .zero)
        setupLayout()
        bindActions()
        configureCartView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCartView() {
        sortedCartProducts = Array(MartProductView.cartProducts).sorted(by: { $0.price < $1.price })
        collectionView.layoutIfNeeded()
        collectionView.reloadData()
        updateNoItemLabelAndCheckOutView()
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
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topView.snp.bottom).offset(2)
            make.bottom.equalToSuperview()
        }
        
        addSubview(noItemLabel)
        noItemLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(topView.snp.bottom).offset(50)
        }
        
        addSubview(checkOutView)
        checkOutView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalToSuperview()
        }

        let topContainer = UIView()
        checkOutView.addSubview(topContainer)
        topContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }

        topContainer.addSubview(totalItemsLabel)
        totalItemsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }

        topContainer.addSubview(totalPriceLabel)
        totalPriceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }

        let bottomContainer = UIView()
        checkOutView.addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }

        bottomContainer.addSubview(checkOutButton)
        checkOutButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(0)
            make.width.equalToSuperview()
        }
    }
    
    private func updateNoItemLabelAndCheckOutView() {
        let isEmpty = sortedCartProducts.isEmpty
        noItemLabel.isHidden = !isEmpty
        checkOutView.isHidden = isEmpty

        guard !isEmpty else { return }

        totalItemsLabel.text = "Total (\(sortedCartProducts.count) items)"
        let totalPrice = sortedCartProducts.reduce(0) { $0 + $1.price }
        totalPriceLabel.text = "$\(totalPrice)"
    }
    
    @objc private func checkOutButtonTapped() {
        print("(CartView) Check-out Button tapped")
        
        sortedCartProducts.removeAll()
        MartProductView.cartProducts.removeAll()
        collectionView.reloadData()
        updateNoItemLabelAndCheckOutView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedCartProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartProductCell.identifier, for: indexPath) as? CartProductCell else {
            return UICollectionViewCell()
        }
        let product = sortedCartProducts[indexPath.row]
        cell.delegate = self
        cell.configure(with: product)
        return cell
    }
    
    func didTapRemoveButton(for product: Product) {
        print("(CartView) : didTapRemoveButton - Removing product: \(product.name)")
        sortedCartProducts.removeAll { $0.id == product.id }
        MartProductView.cartProducts.remove(product)
        collectionView.reloadData()
        updateNoItemLabelAndCheckOutView()
    }
}

protocol CartProductCellDelegate: AnyObject {
    func didTapRemoveButton(for product: Product)
}

class CartProductCell: UICollectionViewCell {
    static let identifier = "CartProductCell"
    
    weak var delegate: CartProductCellDelegate?
    private var product: Product?
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendardBold(size: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    
    private let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_x"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendardSemiBold(size: 14)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let indicatorBar: UIView = {
        let view = UIView()
        view.backgroundColor = SOLT_COLOR
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.layer.cornerRadius = 10
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        return stackView
    }()
        
    private let buttonMinus: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_minus_white"), for: .normal)
        return button
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.pretendardSemiBold(size: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let buttonPlus: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_plus_white"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func removeButtonTapped() {
        print("(CartProdcutCell) : removeButtonTapped")
        UIView.animate(withDuration: 0.1, animations: {
            self.removeButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.removeButton.transform = CGAffineTransform.identity
            }) { _ in
                if let product = self.product {
                    self.delegate?.didTapRemoveButton(for: product)
                }
            }
        }
    }
    
    private func setupLayout() {
        let topPart = UIView()
        let middlePart = UIView()
        let bottomPart = UIView()
        
        addSubview(topPart)
        addSubview(middlePart)
        addSubview(bottomPart)
        addSubview(divider)
        
        topPart.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
        }
        
        middlePart.snp.makeConstraints { make in
            make.top.equalTo(topPart.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
        }
        
        bottomPart.snp.makeConstraints { make in
            make.top.equalTo(middlePart.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        topPart.addSubview(priceLabel)
        topPart.addSubview(removeButton)
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(middlePart.snp.top).offset(0)
        }
        
        removeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
            make.height.equalTo(topPart.snp.height)
            make.width.equalTo(removeButton.snp.height)
        }
        
        middlePart.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        bottomPart.addSubview(indicatorBar)
        indicatorBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(middlePart.snp.bottom).offset(0)
            make.width.equalTo(64)
            make.height.equalTo(22)
        }

        indicatorBar.addSubview(buttonMinus)
        indicatorBar.addSubview(quantityLabel)
        indicatorBar.addSubview(buttonPlus)
        
        quantityLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(indicatorBar.snp.width).multipliedBy(0.5)
            make.height.equalToSuperview()
        }
        
        buttonMinus.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.height.equalTo(indicatorBar.snp.height).offset(-12)
            make.width.equalTo(buttonMinus.snp.height)
        }
        
        buttonPlus.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
            make.height.equalTo(indicatorBar.snp.height).offset(-12)
            make.width.equalTo(buttonPlus.snp.height)
        }
    }
    
    func configure(with product: Product) {
        self.product = product
        priceLabel.text = "$\(product.price)"
        nameLabel.text = product.name
        quantityLabel.text = "1"
    }
}
