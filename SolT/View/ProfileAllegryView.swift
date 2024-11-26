import Foundation
import UIKit
import SnapKit
import Then

class ProfileAllergyView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private lazy var titleLabel: UILabel = createLabel(with: "Allergy")
    private let allgeryFoods: [[String]] = [["Milk", "Eggs", "Peanuts", "Tree nuts"],
                                            ["Sesame", "Soy", "Fish", "Shelfish"],
                                            ["Wheat", "Triticale", "Celery", "Carrot"],
                                            ["Avocado", "Bell pepper", "Potato", "Pumpkin"],
                                            ["Mushroom", "Onion", "Mustard", "Spices"]]
    
    private static var savedSelectedAllergies: Set<String> = []
    
    private var selectedAllergies: Set<String> = ProfileAllergyView.savedSelectedAllergies {
        didSet {
            ProfileAllergyView.savedSelectedAllergies = selectedAllergies
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AllergyCell.self, forCellWithReuseIdentifier: AllergyCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // Add title label
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(10)
        }
        
        // Add collectionView
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - Collection View Data Source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return allgeryFoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allgeryFoods[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllergyCell.identifier, for: indexPath) as? AllergyCell else {
            return UICollectionViewCell()
        }
        let allergy = allgeryFoods[indexPath.section][indexPath.row]
        cell.configure(with: allergy, isSelected: selectedAllergies.contains(allergy))
        return cell
    }
    
    // MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let allergy = allgeryFoods[indexPath.section][indexPath.row]
        if selectedAllergies.contains(allergy) {
            selectedAllergies.remove(allergy)
        } else {
            selectedAllergies.insert(allergy)
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    // MARK: - Collection View Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = CGFloat(5 * 3) // 5 spacing between cells + 2 sides of padding
        let width = (collectionView.frame.width - totalSpacing) / 4 // 4 items per row
        return CGSize(width: width, height: 45)
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
}

// MARK: - AllergyCell
class AllergyCell: UICollectionViewCell {
    static let identifier = "AllergyCell"
    
    let VIEW_BORDER_WIDTH: CGFloat = 2
    let VIEW_CORNER_RADIUS: CGFloat = 6
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendardMedium(size: 12)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.layer.cornerRadius = VIEW_CORNER_RADIUS
        contentView.layer.borderWidth = VIEW_BORDER_WIDTH
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview()
//            make.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.textColor = isSelected ? .white : .black
        contentView.layer.borderColor = isSelected ? SOLT_COLOR.cgColor : UIColor.systemGray.cgColor
        contentView.backgroundColor = isSelected ? SOLT_COLOR : .white
    }
}
