//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 30.10.2022.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    private var unusedQuestionCount: Int = 0
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading) {
        self.moviesLoader = moviesLoader
    }
    
    func requestNextQuestion() {
        guard !movies.isEmpty else {
            loadData()
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.unusedQuestionCount).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            let question = self.convert(model: movie)
            self.hideIndexQuestionOrUpdateAllQuestions(index)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(self, question: question)
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let mostPopularMovies):
                var errorMessage = mostPopularMovies.errorMessage
                if errorMessage.isEmpty, mostPopularMovies.items.isEmpty {
                    errorMessage = "The data is not loaded!"
                }
                if !errorMessage.isEmpty {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.delegate?.didFailToLoadData(self, with: ServiceError.general(reason: errorMessage))
                    }
                    return
                }
                
                self.movies = mostPopularMovies.items
                self.unusedQuestionCount = self.movies.count
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didLoadDataFromServer(self)
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didFailToLoadData(self, with: error)
                }
            }
        }
    }
    
    private func convert(model: MostPopularMovie) -> QuizQuestion {
        var imageData = Data()
        var hint = ""
        do {
            imageData = try Data(contentsOf: model.resizedImageURL)
        } catch {
            hint = "\(model.title) "
        }
        
        let rating = Float(model.rating) ?? 0
        let wordHowCompare = ["больше", "меньше"].randomElement() ?? "больше"
        let addition = Float((0...15).randomElement() ?? 0) / 10
        let number = 8.0 + addition
        
        let text = "\(hint)Рейтинг этого фильма \(wordHowCompare) чем \(number)?"
        let correctAnswer = wordHowCompare == "больше" ? rating > number : rating < number
        
        return QuizQuestion(image: imageData,
                            text: text,
                            correctAnswer: correctAnswer)
    }
    
    private func hideIndexQuestionOrUpdateAllQuestions(_ index: Int) {
        guard unusedQuestionCount > 1 else {
            unusedQuestionCount = movies.count
            return
        }
        
        unusedQuestionCount -= 1
        if index != unusedQuestionCount {
            movies.swapAt(index, unusedQuestionCount)
        }
    }
}
