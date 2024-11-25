
import Foundation
import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class JupiterButtonView: UIView {
    let ANIMATION_DURATION = 0.2
    let BUTTON_COLOR: String = "#06244B"
    
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
    private var innerButtons: [UIButton] = []

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
        
        let allButtonPositions = buttonPositions + arcPositions
        
        // Create buttons at the center of the circleView
        innerButtons.forEach { $0.removeFromSuperview() }
        innerButtons = allButtonPositions.map { _ in
            let button = createButton()
            button.center = jupiterImageView.center // Initial position
            button.alpha = 0 // Initially hidden
            circleView.addSubview(button)
            return button
        }
        
        // Animate circleView and buttons together
        circleView.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0, options: .curveEaseOut, animations: {
            // Expand the circleView
            self.circleView.transform = CGAffineTransform.identity
            
            // Move buttons to their target positions
            for (button, targetOffset) in zip(self.innerButtons, allButtonPositions) {
                button.center = CGPoint(x: self.jupiterImageView.center.x + targetOffset.0,
                                         y: self.jupiterImageView.center.y + targetOffset.1)
                button.alpha = 1 // Make buttons fully visible
            }
        })
    }

    // Helper function to create a button
    private func createButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(hex: BUTTON_COLOR)
        button.layer.cornerRadius = buttonSize / 2
        button.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        return button
    }
}
