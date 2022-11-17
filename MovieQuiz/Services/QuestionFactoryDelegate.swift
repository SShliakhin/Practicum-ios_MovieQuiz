//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 31.10.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(_ questionFactory: QuestionFactoryProtocol, question: QuizQuestion?)
    func didLoadDataFromServer(_ questionFactory: QuestionFactoryProtocol)
    func didFailToLoadData(_ questionFactory: QuestionFactoryProtocol, with error: Error)
}
