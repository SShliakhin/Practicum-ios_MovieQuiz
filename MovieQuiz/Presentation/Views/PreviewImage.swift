//
//  PreviewImage.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 21.11.2022.
//

import UIKit

class PreviewImage: UIView {
    private var isFlipped = true
    private var frontImageView = UIImageView()
    private var backImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
        applyLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
extension PreviewImage {
    private func applyStyle() {
        frontImageView.image = UIImage()
        frontImageView.contentMode = .scaleAspectFit
        backImageView.image = UIImage()
        backImageView.contentMode = .scaleAspectFit
    }
    
    private func applyLayout() {
        [frontImageView, backImageView].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            addSubview(item)
            NSLayoutConstraint.activate([
                item.topAnchor.constraint(equalTo: topAnchor),
                item.bottomAnchor.constraint(equalTo: bottomAnchor),
                item.leadingAnchor.constraint(equalTo: leadingAnchor),
                item.trailingAnchor.constraint(equalTo: trailingAnchor),
                item.heightAnchor.constraint(equalTo: item.widthAnchor, multiplier: Theme.imageHeightAspect)
            ])
        }
    }
}

// MARK: - Action
extension PreviewImage {
    func flipOver() {
        isFlipped.toggle()
        let fromView = isFlipped ? backImageView : frontImageView
        let toView = isFlipped ? frontImageView : backImageView
        
        UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.curveEaseOut, .transitionFlipFromLeft, .showHideTransitionViews])
    }
    
    func setFrontImage(_ image: UIImage) {
        frontImageView.image = image
    }
    func setBackImage(_ image: UIImage) {
        backImageView.image = image
    }
}
