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
}
