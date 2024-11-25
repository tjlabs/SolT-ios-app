import UIKit
import WebKit
import Lottie

class MainViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    private var bottomButtons: [UIButton] = []
    
    let url = URL(string: "https://www.solumesl.com/en/solution/newtonpro?gad_source=1&gbraid=0AAAAACNvyjn4ta_VP-8mIIjTYbxU4aTgJ&gclid=Cj0KCQiA0fu5BhDQARIsAMXUBOIW6-wfzxDclixpW1J_KmA60NpSzJ-TJwOJej75BWfBGGTQOOKy2vIaAk50EALw_wcB")!
    let bottomTapViewHeight: CGFloat = 70
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadWebView()
        setBottomTapBar()
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()

        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.uiDelegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
    }
    
    private func loadWebView() {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60 * 60 * 24)
        webView.load(request)
    }
    
    private func setBottomTapBar() {
        let bottomSafeArea = view.safeAreaInsets.bottom
        let bottomTapViewY = view.bounds.height - bottomTapViewHeight - bottomSafeArea
        let bottomTapView = UIView(frame: CGRect(x: 0, y: bottomTapViewY, width: view.bounds.width, height: bottomTapViewHeight))
        bottomTapView.backgroundColor = .systemGray6
        bottomTapView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        view.addSubview(bottomTapView)

        let buttonWidth: CGFloat = bottomTapView.frame.width / 5
        let buttonHeight: CGFloat = bottomTapView.frame.height

        let icons = ["icon_bottom_home", "icon_bottom_search", "icon_bottom_jupiter", "icon_bottom_bell", "icon_bottom_logout"]
        for (index, iconName) in icons.enumerated() {
            let button = UIButton(frame: CGRect(x: buttonWidth * CGFloat(index), y: -5, width: buttonWidth, height: buttonHeight))

            if !iconName.isEmpty, let icon = UIImage(named: iconName) {
                var imgScale = 2.5
                if iconName == "icon_bottom_logout" {
                    imgScale = 1.2
                }
                let scaledIcon = icon.withRenderingMode(.alwaysOriginal).resize(to: CGSize(width: icon.size.width / imgScale, height: icon.size.height / imgScale))
                button.setImage(scaledIcon, for: .normal)
                button.imageView?.contentMode = .center
            }

            button.tag = index
            button.accessibilityIdentifier = iconName
            button.addTarget(self, action: #selector(tapButtonTapped(_:)), for: .touchUpInside)
            bottomTapView.addSubview(button)
            bottomButtons.append(button)
        }
        
        setScanningMovingImg { success, message in
            print(message)
        }
    }

    
    func hideIconBottomJupiter() {
        if let jupiterButton = bottomButtons.first(where: { $0.accessibilityIdentifier == "icon_bottom_jupiter" }) {
            jupiterButton.isHidden = true
        }
    }
    
    func showIconBottomJupiter() {
        if let jupiterButton = bottomButtons.first(where: { $0.accessibilityIdentifier == "icon_bottom_jupiter" }) {
            jupiterButton.isHidden = false
        }
    }
    
    func setScanningMovingImg(completion: @escaping (Bool, String) -> Void) {
        guard let iconJupiter = bottomButtons.first(where: { $0.accessibilityIdentifier == "icon_bottom_jupiter" }) else {
            completion(false, "Jupiter button not found")
            return
        }
        
        let buttonFrameInMainView = iconJupiter.superview?.convert(iconJupiter.frame, to: view) ?? iconJupiter.frame
        
        let animationView = LottieAnimationView(name: "scan_effect")
        animationView.frame = buttonFrameInMainView
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore
        
        animationView.isUserInteractionEnabled = false
        view.insertSubview(animationView, belowSubview: iconJupiter)
        animationView.play { finished in
            completion(finished, finished ? "Animation completed" : "Animation interrupted")
        }
    }

        
    @objc private func tapButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            print("Home button tapped")
        case 1:
            print("Search button tapped")
        case 2:
            print("Jupiter button tapped")
            showJupiterButtonView()
        case 3:
            print("Notifications button tapped")
        case 4:
            print("Logout button tapped")
        default:
            break
        }
    }
    
    private func showJupiterButtonView() {
        let jupiterButtonView = JupiterButtonView(frame: view.bounds)
        view.addSubview(jupiterButtonView)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return nil
    }
}

extension MainViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView is Loaded!!!!")
        setBottomTapBar()
    }
}

