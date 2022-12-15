//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 08.11.2022.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?
    init (viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func displayAlert(_ model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        
        // Tests
        alert.view.accessibilityIdentifier = "ALERT"
        
        viewController?.present(alert, animated: true)
    }
}
