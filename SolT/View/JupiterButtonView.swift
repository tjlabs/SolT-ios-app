
import Foundation
import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

protocol JupiterButtonViewDelegate: AnyObject {
    func jupiterButtonView(_ jupiterButtonView: JupiterButtonView, didSelectButtonWithLabel label: String)
}

class JupiterButtonView: UIView {
    weak var delegate: JupiterButtonViewDelegate?
    
    let ANIMATION_DURATION = 0.2
    let BUTTON_COLOR: String = "#06244B"
    let buttonTextLabels = [
        "LIVE",
        "PROFILE",
        "MAP",
        "CART",
        "MART"
    ]
    
    private let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()

    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        return view
    }()

    private let jupiterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var circleDiameter: CGFloat = 0
    private let buttonSpacing: CGFloat = 25
    private let buttonSize: CGFloat = 60
    private let buttonLabelOffset: CGFloat = 10
    private var innerButtons: [UIButton] = []
    private var buttonLabels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupGestureRecognizers()
        performCircleAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        // Add blackView to cover the screen
        addSubview(blackView)
        blackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blackView.topAnchor.constraint(equalTo: topAnchor),
            blackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Add circleView
        addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false

        let diameter = UIScreen.main.bounds.width - 40
        self.circleDiameter = diameter

        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: diameter),
            circleView.heightAnchor.constraint(equalToConstant: diameter),
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: bottomAnchor, constant: -(diameter * 0.2))
        ])

        circleView.layer.cornerRadius = diameter / 2

        // Add jupiterImageView
        circleView.addSubview(jupiterImageView)
        jupiterImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            jupiterImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            jupiterImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            jupiterImageView.widthAnchor.constraint(equalTo: circleView.widthAnchor, multiplier: 0.3),
            jupiterImageView.heightAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 0.3)
        ])

        if let image = UIImage(named: "icon_jupiter_navy") {
            let scaleSize = 2.0
            let scaledImage = image.resize(to: CGSize(width: image.size.width * scaleSize, height: image.size.height * scaleSize))
            jupiterImageView.image = scaledImage
        }
    }
    
    // Method to set up buttons
    private func setupButtons() {
        // Creating buttons and assigning actions
        for (index, button) in innerButtons.enumerated() {
            button.tag = index
            button.addTarget(self, action: #selector(innerButtonTapped(_:)), for: .touchUpInside)
        }
    }

    private func setupGestureRecognizers() {
        // Dismiss view when blackView is tapped
        let blackViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        blackView.isUserInteractionEnabled = true
        blackView.addGestureRecognizer(blackViewTapGesture)

        // Dismiss view when jupiterImageView is tapped
        let imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        jupiterImageView.isUserInteractionEnabled = true
        jupiterImageView.addGestureRecognizer(imageViewTapGesture)
    }

    @objc private func dismissView() {
        UIView.animate(withDuration: ANIMATION_DURATION, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }

    
    private func performCircleAnimation() {
        // Ensure `circleView` layout is finalized before animation
        self.layoutIfNeeded()
        
        let diameter = circleDiameter
        let radius = diameter / 2 - buttonSpacing
        
        // Pre-calculate button target positions
        let buttonPositions: [(CGFloat, CGFloat)] = [
            (-radius + buttonSize / 2, 0), // Button 1: Left
            (radius - buttonSize / 2, 0),  // Button 2: Right
            (0, -radius + buttonSize / 2)  // Button 3: Top
        ]
        
        let angleBetweenButtons = CGFloat.pi / 4
        let arcRadius = radius - (buttonSize / 2)
        let arcPositions: [(CGFloat, CGFloat)] = [
            (-arcRadius * cos(angleBetweenButtons), -arcRadius * sin(angleBetweenButtons)), // Button 4
            (arcRadius * cos(angleBetweenButtons), -arcRadius * sin(angleBetweenButtons))  // Button 5
        ]
        
        // Combine and reorder button positions as 1, 4, 3, 5, 2
        let allButtonPositions = [
            buttonPositions[0], // Button 1
            arcPositions[0],    // Button 4
            buttonPositions[2], // Button 3
            arcPositions[1],    // Button 5
            buttonPositions[1]  // Button 2
        ]
        
        // Map button images to corresponding keys
        let buttonImages = [
            "icon_ad_white",       // Image for Button 1
            "icon_profile_white", // Image for Button 4
            "icon_map_white",        // Image for Button 3
            "icon_cart_white",       // Image for Button 5
            "icon_mart_white"         // Image for Button 2
        ]
        
        // Create a dictionary to store button positions
        var buttonPositionDictionary: [String: CGPoint] = [:]

        // Create buttons at the center of the circleView
//        innerButtons.forEach { $0.removeFromSuperview() }
        innerButtons.forEach { $0.removeFromSuperview() }
        buttonLabels.forEach { $0.removeFromSuperview() }
        innerButtons.removeAll()
        buttonLabels.removeAll()
        
        innerButtons = allButtonPositions.enumerated().map { index, position in
            let button = createButton()
            
            // Set the button image
            if index < buttonImages.count, let image = UIImage(named: buttonImages[index]) {
                let scaledImage = image.resize(to: CGSize(width: buttonSize * 0.6, height: buttonSize * 0.6))
                button.setImage(scaledImage, for: .normal)
            }
            
            button.center = jupiterImageView.center // Initial position
            button.alpha = 0 // Initially hidden
            circleView.addSubview(button)
            
            // Create and configure label
            let label = createLabel(withText: buttonTextLabels[index])
            label.center = CGPoint(x: button.center.x, y: button.center.y + buttonSize / 2 + buttonLabelOffset)
            label.alpha = 0 // Initially hidden
            circleView.addSubview(label)
            buttonLabels.append(label)
            
            // Save the button's final position in the dictionary
            let buttonName = "\(index + 1)"
            let finalPosition = CGPoint(x: jupiterImageView.center.x + position.0,
                                        y: jupiterImageView.center.y + position.1)
            buttonPositionDictionary[buttonName] = finalPosition

            return button
        }

        // Animate circleView and buttons together
        circleView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0, options: .curveEaseOut, animations: { [self] in
            // Expand the circleView
            self.circleView.transform = CGAffineTransform.identity

            // Move buttons to their target positions
            for (index, position) in allButtonPositions.enumerated() {
                let button = self.innerButtons[index]
                let label = self.buttonLabels[index]
                button.center = CGPoint(x: self.jupiterImageView.center.x + position.0,
                                        y: self.jupiterImageView.center.y + position.1)
                label.center = CGPoint(x: button.center.x, y: button.center.y + self.buttonSize / 2 + buttonLabelOffset)
                button.alpha = 1
                label.alpha = 1
            }
        }, completion: { [self] _ in
            setupButtons()
        })
    }
    
//    @objc private func innerButtonTapped(_ sender: UIButton) {
//        let label = buttonLabels[sender.tag].text ?? ""
//        delegate?.jupiterButtonView(self, didSelectButtonWithLabel: label)
//    }
    
    @objc private func innerButtonTapped(_ sender: UIButton) {
        let label = buttonLabels[sender.tag].text ?? ""

        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform.identity
            }, completion: { _ in
                self.delegate?.jupiterButtonView(self, didSelectButtonWithLabel: label)
            })
        })
    }


    private func createButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(hex: BUTTON_COLOR)
        button.layer.cornerRadius = buttonSize / 2
        button.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }
    
    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = UIFont.pretendardSemiBold(size: 14)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }
}
