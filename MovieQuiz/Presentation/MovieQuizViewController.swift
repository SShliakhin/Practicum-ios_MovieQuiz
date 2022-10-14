import UIKit

final class MovieQuizViewController: UIViewController {
    
    private let buttonsStackView = UIStackView()
    private let yesButton = UIButton()
    private let noButton = UIButton()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        applyStyle()
        applyLayout()
    }
}

// MARK: - Private methods
extension MovieQuizViewController {
    private func setup() {
        yesButton.addTarget(self, action: #selector(yesButtonTapped), for: .primaryActionTriggered)
        noButton.addTarget(self, action: #selector(noButtonTapped), for: .primaryActionTriggered)
    }

    private func applyStyle() {
        view.backgroundColor = UIColor.ypBlack
        
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.spacing = 20
        
        applyStyleAnswerButton(for: yesButton, title: "Да")
        applyStyleAnswerButton(for: noButton, title: "Нет")
    }
    
    private func applyStyleAnswerButton(for button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "YS Display-Medium", size: 16)
        button.setTitleColor(UIColor.ypBlack, for: .normal)
        button.backgroundColor = UIColor.ypWhite
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
    }

    private func applyLayout() {
        [ noButton,
          yesButton
        ].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            buttonsStackView.addArrangedSubview(item)
        }
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 718),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -34),
            
            noButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 158),
            noButton.heightAnchor.constraint(equalToConstant: 60),
            yesButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 158),
            yesButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - Actions
extension MovieQuizViewController {
    @objc func yesButtonTapped() {
        print("Select YES")
    }
    
    @objc func noButtonTapped() {
        print("Select NO")
    }
}

// MARK: - Color
extension UIColor {
    static var ypBlack: UIColor { UIColor(named: "black")! }
    static var ypGray: UIColor { UIColor(named: "gray")! }
    static var ypGreen: UIColor { UIColor(named: "green")! }
    static var ypRed: UIColor { UIColor(named: "red")! }
    static var ypWhite: UIColor { UIColor(named: "white")! }
    static var ypBackground: UIColor { UIColor(named: "background")! }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
