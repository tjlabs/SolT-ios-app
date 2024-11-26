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
        view.backgroundColor = .blue
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
    
    init(title: String, sector_id: Int, region: String) {
        self.titleText = title
        super.init(frame: .zero)
        setupLayout()
        bindActions()
        setOlympusMapView()
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
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
//    private func setOlympusMapView() {
//        mapView.configureFrame(to: mainView)
//        mainView.addSubview(mapView)
//        OlympusMapManager.shared.loadMap(region: "Korea", sector_id: sector_id, mapView: mapView)
//    }
    
    private func setOlympusMapView() {
        // Add `mapView` to `mainView`
        mainView.addSubview(mapView)
        
        // Use Auto Layout to set constraints
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: mainView.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor)
        ])
        
        // Load map data
        OlympusMapManager.shared.loadMap(region: "Korea", sector_id: sector_id, mapView: mapView)
    }

}
