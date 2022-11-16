//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 31.10.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    
    func requestNextQuestion()
}
