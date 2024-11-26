import UIKit
import RxSwift
import RxCocoa
import OlympusSDK

class MapView: UIView {
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var topView = TopView(title: titleText)
    private let disposeBag = DisposeBag()
    
    var titleText: String = "Default Title"
    var onBackButtonTapped: (() -> Void)?
    
    // User Info
    let mapView = OlympusMapView()
    var sector_id: Int = 0
    var region: String = ""
    
    init(title: String, region: String, sector_id: Int) {
        self.titleText = title
        super.init(frame: .zero)
        setupLayout()
        bindActions()
        self.sector_id = sector_id
        self.region = region
        setOlympusMapView(region: region, sector_id: sector_id)
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
        
        addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func setOlympusMapView(region: String, sector_id: Int) {
        mapView.configureFrame(to: mainView)
        mainView.addSubview(mapView)
        OlympusMapManager.shared.loadMap(region: region, sector_id: sector_id, mapView: mapView)
    }
}
