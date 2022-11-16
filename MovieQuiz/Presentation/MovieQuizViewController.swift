import UIKit

final class MovieQuizViewController: UIViewController {
    
    private let mainStackView = UIStackView()
    
    private let questionTitleStackView = UIStackView()
    private let questionTitleLabel = UILabel()
    private let questionIndexLabel = UILabel()
    
    private let previewImageViewStackView = UIStackView()
    private let leftPaddingView = UIView()
    private let rightPaddingView = UIView()
    private let previewImageView = UIImageView()
    
    private let questionLabelView = UIView()
    private let questionLabel = UILabel()
    
    private let buttonsStackView = UIStackView()
    private let yesButton = UIButton()
    private let noButton = UIButton()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - Properties
    private var currentQuestionIndex = 0 {
        didSet {
            showLoadingIndicator()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.hideLoadingIndicator()
                strongSelf.questionFactory?.requestNextQuestion()
            }
        }
    }
    
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        applyStyle()
        applyLayout()
        
        startQuiz()
    }
}

// MARK: - State's methods
extension MovieQuizViewController {
    private func startQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }

    private func show(quiz step: QuizStepViewModel) {
        questionIndexLabel.text = step.questionNumber
        previewImageView.image = step.image
        questionLabel.text = step.question
        
        setPreviewImageViewBorder()
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ) { [weak self] in
            self?.startQuiz()
        }
        
        alertPresenter?.displayResult(alertModel, over: self)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1,
           let statistics = statisticService {
            statistics.store(correct: correctAnswers, total: questionsAmount)
            
            let bestGame = statistics.bestGame
            let text = """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(statistics.gamesCount)
                Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                Средняя точность: \(String(format: "%.2f", statistics.totalAccuracy))%
                """
            let result = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: result)
        } else {
            currentQuestionIndex += 1
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        let color = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        setPreviewImageViewBorder(width: Theme.imageAnswerBorderWidht, color: color)
        
        [noButton, yesButton].forEach { $0.isEnabled.toggle() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showNextQuestionOrResults()
            [strongSelf.noButton, strongSelf.yesButton].forEach { $0.isEnabled.toggle() }
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let alert = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз"
        ) { [weak self] in
            self?.startQuiz()
        }
        alertPresenter?.displayResult(alert, over: self)
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}

// MARK: - Private methods setup and UI
extension MovieQuizViewController {
    private func setup() {
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
        questionFactory?.delegate = self
        
        alertPresenter = AlertPresenter()
        statisticService = StatisticServiceImplementation()
        
        yesButton.addTarget(self, action: #selector(yesButtonTapped), for: .primaryActionTriggered)
        noButton.addTarget(self, action: #selector(noButtonTapped), for: .primaryActionTriggered)
    }

    private func applyStyle() {
        view.backgroundColor = .ypBlack
        
        applyStyleLabel(for: questionTitleLabel, text: "Вопрос:")
        applyStyleLabel(for: questionIndexLabel, text: "1/10", textAlignment: .right)
        
        previewImageView.contentMode = .scaleAspectFill
        previewImageView.backgroundColor = .ypWhite
        previewImageView.layer.cornerRadius = Theme.imageCornerRadius
        previewImageView.layer.masksToBounds = true
        
        questionLabelView.backgroundColor = .ypBlack
        
        applyStyleLabel(
            for: questionLabel,
               text: "Рейтинг этого фильма меньше чем 5?",
               font: Theme.boldLargeFont,
               textAlignment: .center,
               numberOfLines: 0)
        
        applyStyleAnswerButton(for: yesButton, title: "Да")
        applyStyleAnswerButton(for: noButton, title: "Нет")
        
        activityIndicator.isHidden = true
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
        text: String,
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
        button.layer.masksToBounds = true // стоит ли выставлять? Критично только для image
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
    @objc func yesButtonTapped() {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: true == currentQuestion.correctAnswer)
    }
    
    @objc func noButtonTapped() {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: false == currentQuestion.correctAnswer)
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didRecieveNextQuestion(_ questionFactory: QuestionFactoryProtocol, question: QuizQuestion?) {
        // TODO: - здесь уже должны быть на главном потоке
        guard let question = question else {
            showNetworkError(message: "Сетевая ошибка")
            return
        }

        hideLoadingIndicator()
        
        currentQuestion = question
        let quiz = convert(model: question)
        // TODO: - лучше оборачивать в сервисе
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: quiz)
        }
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        currentQuestionIndex = 1
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
