
import Foundation
import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class ProfileUserInfoView: UIView {
    let VIEW_BORDER_WIDTH: CGFloat = 4
    let VIEW_CORNER_RADIOUS: CGFloat = 10
    let DESELECT_COLOT: UIColor = .systemGray5
    
    private let stackViewForContents: UIStackView = {
        let stackView = UIStackView()
//        stackView.backgroundColor = .yellow
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    private let stackViewForGender: UIStackView = {
        let stackView = UIStackView()
//        stackView.backgroundColor = .red
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var maleContainerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .systemGray3
        return view
    }()
    
    private lazy var maleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.borderWidth = VIEW_BORDER_WIDTH
        view.borderColor = SOLT_COLOR
        view.cornerRadius = VIEW_CORNER_RADIOUS
        return view
    }()
    
    private var maleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "icon_male_select")
    }
    
    let maleLabel = UILabel().then {
        $0.font = UIFont.pretendardBold(size: 12)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.text = "Male"
    }
    
    private lazy var femaleContainerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .systemGray3
        return view
    }()
    
    private lazy var femaleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.borderWidth = VIEW_BORDER_WIDTH
        view.borderColor = DESELECT_COLOT
        view.cornerRadius = VIEW_CORNER_RADIOUS
        return view
    }()
    
    private var femaleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "icon_female_deselect")
    }
    
    let femaleLabel = UILabel().then {
        $0.font = UIFont.pretendardBold(size: 12)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.text = "Female"
    }
    
    private let stackViewForVegan: UIStackView = {
        let stackView = UIStackView()
//        stackView.backgroundColor = .blue
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var veganContainerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .systemGray3
        return view
    }()
    
    private lazy var veganView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.borderWidth = VIEW_BORDER_WIDTH
        view.borderColor = DESELECT_COLOT
        view.cornerRadius = VIEW_CORNER_RADIOUS
        return view
    }()
    
    private var veganImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "icon_vegan_deselect")
    }
    
    let veganLabel = UILabel().then {
        $0.font = UIFont.pretendardBold(size: 12)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.text = "VEGAN"
    }
    
    private lazy var nonveganContainerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .systemGray3
        return view
    }()
    
    private lazy var nonveganView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.borderWidth = VIEW_BORDER_WIDTH
        view.borderColor = NONVEGAN_COLOR
        view.cornerRadius = VIEW_CORNER_RADIOUS
        return view
    }()
    
    private var nonveganImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "icon_nonvegan_select")
    }
    
    let nonveganLabel = UILabel().then {
        $0.font = UIFont.pretendardBold(size: 12)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.text = "NON-VEG"
    }
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
//        backgroundColor = .brown
        self.snp.makeConstraints { make in
            make.height.equalTo(112)
        }
        
        addSubview(stackViewForContents)
        stackViewForContents.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
            
        stackViewForContents.addArrangedSubview(stackViewForGender)
        stackViewForContents.addArrangedSubview(stackViewForVegan)
            
        stackViewForGender.addArrangedSubview(maleContainerView)
        stackViewForGender.addArrangedSubview(femaleContainerView)
            
        stackViewForVegan.addArrangedSubview(veganContainerView)
        stackViewForVegan.addArrangedSubview(nonveganContainerView)
            
        maleContainerView.addSubview(maleView)
        maleContainerView.addSubview(maleLabel)
        maleView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(maleView.snp.width)
        }
        maleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(maleView.snp.bottom).offset(0)
            make.bottom.equalToSuperview().inset(0)
        }
        maleView.addSubview(maleImageView)
        maleImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(10)
        }
        
        femaleContainerView.addSubview(femaleView)
        femaleContainerView.addSubview(femaleLabel)
        femaleView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(femaleView.snp.width)
        }
        femaleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(maleView.snp.bottom).offset(0)
            make.bottom.equalToSuperview().inset(0)
        }
        femaleView.addSubview(femaleImageView)
        femaleImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(10)
        }
        
        veganContainerView.addSubview(veganView)
        veganContainerView.addSubview(veganLabel)
        veganView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(veganView.snp.width)
        }
        veganLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(maleView.snp.bottom).offset(0)
            make.bottom.equalToSuperview().inset(0)
        }
        veganView.addSubview(veganImageView)
        veganImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(15)
        }
        
        nonveganContainerView.addSubview(nonveganView)
        nonveganContainerView.addSubview(nonveganLabel)
        nonveganView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(nonveganView.snp.width)
        }
        nonveganLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(maleView.snp.bottom).offset(0)
            make.bottom.equalToSuperview().inset(0)
        }
        nonveganView.addSubview(nonveganImageView)
        nonveganImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(15)
        }
//        maleView.snp.makeConstraints { make in
//            make.height.equalTo(maleView.snp.width)
//        }
//        femaleView.snp.makeConstraints { make in
//            make.height.equalTo(femaleView.snp.width)
//        }
            
//        veganView.snp.makeConstraints { make in
//            make.height.equalTo(veganView.snp.width)
//        }
//        nonveganView.snp.makeConstraints { make in
//            make.height.equalTo(nonveganView.snp.width)
//        }
        
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}


