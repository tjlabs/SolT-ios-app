import Foundation
import UIKit
import SnapKit
import Then

class MartCategoryView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private lazy var titleLabel: UILabel = createLabel(with: "Category")
    private lazy var seeAllLabel: UILabel = createSmallLabel(with: "See all")
    private let categoryNames: [String] = ["Food", "Beauty", "Clothes", "Toy"]
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        return collectionView
    }()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(145)
        }
        
        // Title Label
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
        }
        
        // See All Label
        addSubview(seeAllLabel)
        seeAllLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
        }
        
        // CollectionView
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }
        
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Helper Methods
    private func createLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
        label.text = text
        return label
    }
    
    private func createSmallLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        label.textColor = .black
        label.text = text
        return label
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: categoryNames[indexPath.row])
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100) // Adjust size to fit circular view and label
    }
}

// MARK: - CategoryCell
class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = SOLT_COLOR
        view.layer.cornerRadius = 30 // Half of width/height for circular shape
        view.layer.masksToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendardSemiBold(size: 14)
        label.textAlignment = .center
        label.textColor = .black
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
        contentView.addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.width.height.equalTo(60) // Circle size
            make.top.centerX.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
