//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 30.10.2022.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private var questions: [QuizQuestion] = []
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate?) {
        self.delegate = delegate
        questions = loadMockData()
    }
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didRecieveNextQuestion(self, question: nil)
            return
        }
        let question = questions[safe: index]
        if question != nil {
            deleteIndexQuestionOrReloadQuestions(index)
        }
        delegate?.didRecieveNextQuestion(self, question: question)
    }
    
    private func deleteIndexQuestionOrReloadQuestions(_ index: Int) {
        guard questions.count != 1 else {
            questions = loadMockData()
            return
        }
        
        let lastIndex = questions.count - 1
        if index != lastIndex {
            questions.swapAt(index, lastIndex)
        }
        questions.removeLast()
    }
}

// MARK: - Mock data
extension QuestionFactory {
    private func loadMockData() -> [QuizQuestion]{
        [
            QuizQuestion(
                image: "The Godfather",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Dark Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Kill Bill",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Avengers",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Deadpool",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "The Green Knight",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: true),
            QuizQuestion(
                image: "Old",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "The Ice Age Adventures of Buck Wild",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Tesla",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false),
            QuizQuestion(
                image: "Vivarium",
                text: "Рейтинг этого фильма больше чем 6?",
                correctAnswer: false)
        ]
    }
}
