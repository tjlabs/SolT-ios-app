import Foundation
import UIKit
import SnapKit
import Then

class MartAdView: UIView {
    private let stackViewForAdImages: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 2 // Set the spacing between images
        return stackView
    }()
    
    private let bigImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "img_mart_ad_1")
    }
    
    private let smallImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "img_mart_ad_2")
    }
    
    private var aspectRatioConstraint: NSLayoutConstraint?
    
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
        addSubview(stackViewForAdImages)
        stackViewForAdImages.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        // Add images to stackView
        stackViewForAdImages.addArrangedSubview(bigImageView)
        stackViewForAdImages.addArrangedSubview(smallImageView)
        
        calculateDynamicHeight()
    }
    
    private func calculateDynamicHeight() {
        guard let bigImage = bigImageView.image, let smallImage = smallImageView.image else { return }
        
        // Calculate the heights of both images based on their intrinsic aspect ratios
        let bigImageAspectRatio = bigImage.size.height / bigImage.size.width
        let smallImageAspectRatio = smallImage.size.height / smallImage.size.width
        
        let combinedHeight = bigImage.size.height + 50

        // Set the dynamic height of MartAdView
        self.snp.makeConstraints { make in
            make.height.equalTo(combinedHeight)
        }
    }
}
