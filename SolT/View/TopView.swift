
import Foundation
import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class TopView: UIView {
    
    private var title: String?
    
    var backButtonTapped: Observable<Void> {
        return backButton.rx.tap.asObservable()
    }
    
    private let backButton = UIButton().then {
        $0.setImage(UIImage(named: "back_button"), for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.pretendardBold(size: 20)
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.title = title
        setupLayout(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(title: String) {
        addSubview(backButton)
        addSubview(titleLabel)
        backButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(60)
            make.leading.equalToSuperview()
        }
        
        titleLabel.text = title
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }

    }
}


