//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 30.10.2022.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private var questions: [QuizQuestion] = []
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading) {
        self.moviesLoader = moviesLoader
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
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let mostPopularMovies):
                self.movies = mostPopularMovies.items
                self.delegate?.didLoadDataFromServer()
            case .failure(let error):
                self.delegate?.didFailToLoadData(with: error)
            }
        }
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
