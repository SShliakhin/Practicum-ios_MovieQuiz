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

final class MovieQuizViewControllerProtocolMock: UIViewController, MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) { }
    func showAnswerResult(isCorrect: Bool) { }
    func prepareLoadQuestion() { }
    func hideLoadingIndicator() { }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerProtocolMock()
        let sut = MovieQuizPresenter()
        sut.viewController = viewControllerMock

        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)

        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
