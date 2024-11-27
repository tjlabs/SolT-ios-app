import UIKit
import SnapKit
import Kingfisher

import UIKit
import SnapKit
import Kingfisher

class MartProductView: UIView {
    private var products: [Product] = []
    private var selectedProducts: [Product] = []
    static var cartProducts = Set<Product>()

    private let CELL_NUM_IN_ROW: CGFloat = 3
    private let CELL_INSET: CGFloat = 10
    private let CELL_SPACING: CGFloat = 10

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = CELL_SPACING
        layout.sectionInset = UIEdgeInsets(top: 0, left: CELL_INSET, bottom: 0, right: CELL_INSET)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var addToCartView: UIView = {
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

    private let addToCartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.pretendardExtraBold(size: 22)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()

    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(addToCartView)
        addToCartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalToSuperview()
        }

        let topContainer = UIView()
        addToCartView.addSubview(topContainer)
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
        addToCartView.addSubview(bottomContainer)
        bottomContainer.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }

        bottomContainer.addSubview(addToCartButton)
        addToCartButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(0)
            make.width.equalToSuperview()
        }
    }

    func updateProducts(with products: [Product]) {
        self.products = products
        collectionView.reloadData()
    }

    private func updateAddToCartView() {
        let totalItems = selectedProducts.count
        let totalPrice = selectedProducts.reduce(0) { $0 + $1.price }
        totalItemsLabel.text = "Total (\(totalItems) items)"
        totalPriceLabel.text = "$\(totalPrice)"
        addToCartView.isHidden = totalItems == 0
    }

    @objc private func addToCartButtonTapped() {
        MartProductView.cartProducts = Set(selectedProducts)
        print("Products added to cart: \(MartProductView.cartProducts)")
        
        selectedProducts.removeAll()
        collectionView.reloadData()
        updateAddToCartView()
    }
}

extension MartProductView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalHorizontalSpacing = (CELL_NUM_IN_ROW - 1) * CELL_SPACING + (CELL_INSET * 2)
        let cellWidth = (collectionView.frame.width - totalHorizontalSpacing) / CELL_NUM_IN_ROW
        let cellHeight = cellWidth * 1.4
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        let product = products[indexPath.row]
        cell.configure(with: product, isSelected: selectedProducts.contains(product))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        if let index = selectedProducts.firstIndex(of: product) {
            selectedProducts.remove(at: index)
        } else {
            selectedProducts.append(product)
        }
        collectionView.reloadItems(at: [indexPath])
        updateAddToCartView()
    }
}


class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.pretendardSemiBold(size: 10)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.pretendardBold(size: 14)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(2)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(containerView.snp.width)
        }
        
        containerView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.top.equalTo(imageView.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview()
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-2)
        }
    }

    func configure(with product: Product, isSelected: Bool) {
        titleLabel.text = product.name
        if let url = URL(string: product.url) {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        
        priceLabel.text = "$\(product.price)"
        containerView.backgroundColor = isSelected ? SOLT_COLOR : .systemGray6
        titleLabel.textColor = isSelected ? .white : .black
        priceLabel.textColor = isSelected ? .white : .black
    }
}
