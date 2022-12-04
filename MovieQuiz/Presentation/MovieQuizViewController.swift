import UIKit

final class MovieQuizViewController: UIViewController {
    
    private let mainStackView = UIStackView()
    
    private let questionTitleStackView = UIStackView()
    private let questionTitleLabel = UILabel()
    private let questionIndexLabel = UILabel()
    
    private let previewImageViewStackView = UIStackView()
    private let leftPaddingView = UIView()
    private let rightPaddingView = UIView()
    private let previewImageView = PreviewImage()
    
    private let questionLabelView = UIView()
    private let questionLabel = UILabel()
    
    private let buttonsStackView = UIStackView()
    private let yesButton = UIButton()
    private let noButton = UIButton()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Properties
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        applyStyle()
        applyLayout()
        
        presenter.resetGame()
    }
}

// MARK: - State's methods
extension MovieQuizViewController {
    func show(quiz step: QuizStepViewModel) {
        questionIndexLabel.transformWithScaleAnimation(
            text: step.questionNumber,
            durationStart: 0.2,
            durationFinish: 0.3,
            scale: 1.25)
        previewImageView.setBackImage(step.image)
        previewImageView.flipOver()
        questionLabel.pushUpAnimation(text: step.question, duration: 0.5)
        [noButton, yesButton].forEach { $0.isEnabled = true }
    }
    
    func showAnswerResult(isCorrect: Bool) {
        let color = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        setPreviewImageViewBorder(width: Theme.imageAnswerBorderWidht, color: color)
        
        [noButton, yesButton].forEach { $0.isEnabled = false }
    }
    
    func prepareLoadQuestion() {
        activityIndicator.startAnimating()
        setPreviewImageViewBorder()
        previewImageView.flipOver()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - Private methods setup and UI
extension MovieQuizViewController {
    private func setup() {
        presenter.viewController = self
        
        yesButton.addTarget(self, action: #selector(yesButtonTapped), for: .primaryActionTriggered)
        noButton.addTarget(self, action: #selector(noButtonTapped), for: .primaryActionTriggered)
    }

    private func applyStyle() {
        view.backgroundColor = .ypBlack
        
        applyStyleLabel(for: questionTitleLabel, text: "Вопрос:")
        applyStyleLabel(for: questionIndexLabel, textAlignment: .right)
        
        previewImageView.setBackImage(UIImage(named: "top250") ?? UIImage())
        previewImageView.layer.cornerRadius = Theme.imageCornerRadius
        previewImageView.layer.masksToBounds = true
        
        questionLabelView.backgroundColor = .ypBlack
        
        applyStyleLabel(
            for: questionLabel,
               font: Theme.boldLargeFont,
               textAlignment: .center,
               numberOfLines: 0)
        
        applyStyleAnswerButton(for: yesButton, title: "Да")
        applyStyleAnswerButton(for: noButton, title: "Нет")
        
        activityIndicator.style = .large
    }

    private func applyLayout() {
        arrangeStackView(
            for: questionTitleStackView,
               subviews: [questionTitleLabel, questionIndexLabel])
        
        questionIndexLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        arrangeStackView(
            for: previewImageViewStackView,
               subviews: [leftPaddingView, previewImageView, rightPaddingView])
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabelView.addSubview(questionLabel)
        
        questionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        arrangeStackView(
            for: buttonsStackView,
               subviews: [noButton, yesButton],
               spacing: Theme.spacing,
               distribution: .fillEqually)
        
        arrangeStackView(
            for: mainStackView,
               subviews: [questionTitleStackView, previewImageViewStackView, questionLabelView, buttonsStackView],
               spacing: Theme.spacing,
               axis: .vertical)
        
        [mainStackView, activityIndicator].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Theme.leftOffset),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Theme.leftOffset),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Theme.topOffset),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            previewImageView.heightAnchor.constraint(equalTo: previewImageView.widthAnchor, multiplier: Theme.imageHeightAspect),
            leftPaddingView.widthAnchor.constraint(equalTo: rightPaddingView.widthAnchor),
            
            questionLabel.leadingAnchor.constraint(equalTo: questionLabelView.leadingAnchor, constant: Theme.leftQuestionPadding),
            questionLabel.trailingAnchor.constraint(equalTo: questionLabelView.trailingAnchor, constant: -Theme.leftQuestionPadding),
            questionLabel.topAnchor.constraint(equalTo: questionLabelView.topAnchor, constant: Theme.topQuestionPadding),
            questionLabel.bottomAnchor.constraint(equalTo: questionLabelView.bottomAnchor, constant: -Theme.topQuestionPadding),
            
            buttonsStackView.heightAnchor.constraint(equalToConstant: Theme.buttonHeight),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: previewImageView.centerYAnchor)
        ])
    }
    
    // MARK: - Supporting methods
    private func applyStyleLabel(
        for label: UILabel,
        text: String = "",
        font: UIFont? = Theme.mediumLargeFont,
        textColor: UIColor = .ypWhite,
        textAlignment: NSTextAlignment = .left,
        numberOfLines: Int = 1
    ) {
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
    }
    
    private func applyStyleAnswerButton(for button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = Theme.mediumLargeFont
        button.setTitleColor(.ypBlack, for: .normal)
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = Theme.buttonCornerRadius
        button.layer.masksToBounds = true
        button.isEnabled = false
    }
    
    private func setPreviewImageViewBorder(width: CGFloat = 0, color: CGColor = UIColor.ypWhite.cgColor) {
        previewImageView.layer.borderWidth = width
        previewImageView.layer.borderColor = color
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
    @objc private func yesButtonTapped() {
        presenter.yesButtonTapped()
    }
    
    @objc private func noButtonTapped() {
        presenter.noButtonTapped()
    }
}
