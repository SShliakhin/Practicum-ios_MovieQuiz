//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 08.11.2022.
//

import UIKit

final class AlertPresenter {
    static func displayResult(
        _ model: QuizResultsViewModel,
        over vc: UIViewController,
        completion: @escaping () -> Void
    ) {
        let alert = UIAlertController(
            title: model.title,
            message: model.text,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        
        vc.present(alert, animated: true)
    }
}

extension AlertPresenter: AlertPresenterProtocol {
    func displayResult(_ model: AlertModel, over vc: UIViewController) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        
        vc.present(alert, animated: true)
    }
}
