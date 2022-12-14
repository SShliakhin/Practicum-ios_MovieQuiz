//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by SERGEY SHLYAKHIN on 13.12.2022.
//

import XCTest
@testable import MovieQuiz

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerProtocolMock: MovieQuizViewControllerProtocol {
    private(set) var viewModel: QuizStepViewModel?
    
    func show(quiz step: QuizStepViewModel) {
        viewModel = step
    }
    func showAnswerResult(isCorrect: Bool) {}
    func prepareLoadQuestion() {}
    func hideLoadingIndicator() {}
}

final class QuestionFactoryMock: QuestionFactoryProtocol {
    func requestNextQuestion() {}
    func loadData() {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let statisticService = StatisticServiceImplementation()
        let alertPresenter = AlertPresenter()
        
        let sut = MovieQuizPresenter(
            statisticService: statisticService,
            alertPresenter: alertPresenter,
            viewController: viewControllerMock
        )

        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        sut.didRecieveNextQuestion(QuestionFactoryMock(), question: question)
        
        guard let viewModel = viewControllerMock.viewModel else { return }

        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
