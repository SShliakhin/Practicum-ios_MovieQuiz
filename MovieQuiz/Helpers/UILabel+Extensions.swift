//
//  UILabel+Extensions.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 17.11.2022.
//

import UIKit

extension UILabel {
    func animationTyping(_ value: String, duration: Double) {
        for item in value {
            text?.append(item)
            RunLoop.current.run(until: Date() + duration)
        }
    }
    
    func fadeInOutAnimation(text: String, duration: Double) {
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.subtype = CATransitionSubtype.fromTop
        self.text = text
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    func pushUpAnimation(text: String, duration: Double) {
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        self.text = text
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
    
    func transformWithScaleAnimation(text: String, durationStart: Double, durationFinish: Double, scale: CGFloat) {
        UIView.animate(withDuration: durationStart, animations: { () -> Void in
            self.transform = .init(scaleX: scale, y: scale)
        }) { (finished: Bool) -> Void in
            self.text = text
            UIView.animate(withDuration: durationFinish, animations: { () -> Void in
                self.transform = .identity
            })
        }
    }
}
