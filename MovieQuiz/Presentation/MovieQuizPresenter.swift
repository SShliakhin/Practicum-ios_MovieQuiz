//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 04.12.2022.
//

import UIKit

final class MovieQuizPresenter {
    private var currentQuestionIndex = 0 {
        didSet {
            viewController?.prepareLoadQuestion()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.questionFactory?.requestNextQuestion()
            }
        }
    }
    
    private let questionsAmount: Int = 10
    private var correctAnswers = 0
    private var currentQuestion: QuizQuestion?
    
    private var isLastQuestion: Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private let statisticService: StatisticService
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    
    weak var viewController: MovieQuizViewController?
    
    init() {
        self.statisticService = StatisticServiceImplementation()
        let factory = QuestionFactory(moviesLoader: MoviesLoader())
        factory.delegate = self
        questionFactory = factory
        alertPresenter = AlertPresenter()
    }
    
    // MARK: Public methods
    func resetGame() {
        correctAnswers = 0
        currentQuestionIndex = 0
    }
    
    func yesButtonTapped() {
        didAnswer(isYes: true)
    }
    
    func noButtonTapped() {
        didAnswer(isYes: false)
    }
    
    // MARK: Private methods
    private func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText
        ) { [weak self] in
            self?.resetGame()
        }
        
        if let vc = viewController {
            alertPresenter?.displayAlert(alertModel, over: vc)
        }
    }

    private func showNextQuestionOrResults() {
        if isLastQuestion {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let bestGame = statisticService.bestGame
            let text = """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(statisticService.gamesCount)
                Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
                Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
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
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        let isCorrect = isYes == currentQuestion.correctAnswer
        if isCorrect {
            correctAnswers += 1
        }
        viewController?.showAnswerResult(isCorrect: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
        }
    }
    
    private func showErrorAlert(message: String) {
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз"
        ) { [weak self] in
            self?.resetGame()
        }
        if let vc = viewController {
            alertPresenter?.displayAlert(alertModel, over: vc)
        }
    }
} 

// MARK: - QuestionFactoryDelegate
extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didRecieveNextQuestion(_ questionFactory: QuestionFactoryProtocol, question: QuizQuestion?) {
        viewController?.hideLoadingIndicator()
        guard let question = question else { return }

        currentQuestion = question
        let quiz = convert(model: question)
        viewController?.show(quiz: quiz)
    }
    
    func didLoadDataFromServer(_ questionFactory: QuestionFactoryProtocol) {
        viewController?.hideLoadingIndicator()
        currentQuestionIndex = 0
    }
    
    func didFailToLoadData(_ questionFactory: QuestionFactoryProtocol, with error: Error) {
        viewController?.hideLoadingIndicator()
        var message = error.localizedDescription
        guard let error = error as? ServiceError else {
            showErrorAlert(message: message)
            return
        }
        
        switch error {
        case .network(statusCode: let statusCode):
            message = "Networking error. Status code: \(statusCode)."
        case .parsing:
            message = "JSON data could not be parsed."
        case .general(reason: let reason):
            message = reason
        }
        showErrorAlert(message: message)
    }
}
