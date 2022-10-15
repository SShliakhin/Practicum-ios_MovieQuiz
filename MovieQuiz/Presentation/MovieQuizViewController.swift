import UIKit

final class MovieQuizViewController: UIViewController {
    
    private let mainStackView = UIStackView()
    
    private let questionTitleStackView = UIStackView()
    private let questionTitleLabel = UILabel()
    private let questionIndexLabel = UILabel()
        
    private let previewImageView = UIImageView()
    
    private let containerView = UIView()
    private let questionLabel = UILabel()
    
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
        
        questionTitleLabel.text = "Вопрос:"
        questionTitleLabel.textColor = UIColor.ypWhite
        questionTitleLabel.textAlignment = .left
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        questionIndexLabel.text = "1/10"
        questionIndexLabel.textColor = UIColor.ypWhite
        questionIndexLabel.textAlignment = .right
        questionIndexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        containerView.backgroundColor = .ypBlack
        
        questionLabel.text = "Рейтинг этого фильма меньше чем 5?"
        questionLabel.textColor = UIColor.ypWhite
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        questionLabel.numberOfLines = 0
        
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.backgroundColor = UIColor.ypWhite
        
        applyStyleAnswerButton(for: yesButton, title: "Да")
        applyStyleAnswerButton(for: noButton, title: "Нет")
    }
    
    private func applyStyleAnswerButton(for button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        button.setTitleColor(UIColor.ypBlack, for: .normal)
        button.backgroundColor = UIColor.ypWhite
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
    }

    private func applyLayout() {
        
        arrangeStackView(
            for: questionTitleStackView,
               subviews: [questionTitleLabel, questionIndexLabel])
        
        questionIndexLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        arrangeStackView(
            for: buttonsStackView,
               subviews: [noButton, yesButton],
               spacing: 20,
               distribution: .fillEqually)
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(questionLabel)
        
        arrangeStackView(
            for: mainStackView,
               subviews: [questionTitleStackView, previewImageView, containerView, buttonsStackView],
               spacing: 20,
               axis: .vertical)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            previewImageView.heightAnchor.constraint(equalTo: previewImageView.widthAnchor, multiplier: 3/2),
            
            questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 42),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -42),
            questionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 13),
            questionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -13),
            
            noButton.heightAnchor.constraint(equalToConstant: 60),
            yesButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func arrangeStackView(
        for stackView: UIStackView,
        subviews: [UIView],
        spacing: CGFloat = 0,
        axis: NSLayoutConstraint.Axis = .horizontal,
        distribution: UIStackView.Distribution = .fill,
        aligment: UIStackView.Alignment = .fill
    ) {
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.alignment = aligment
        
        subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(item)
        }
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
