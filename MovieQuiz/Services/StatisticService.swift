//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 10.11.2022.
//

import Foundation

protocol StatisticService {
    var gamesCount: Int { get }
    var totalAccuracy: Double { get }
    var bestGame: GameRecord { get }
    
    func store(correct: Int, total: Int)
}

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct // всего корректных ответов
        case total // всего вопросов
        case bestGame
        case gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    
    private(set) var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        let correct = userDefaults.integer(forKey: Keys.correct.rawValue)
        let total = userDefaults.integer(forKey: Keys.total.rawValue)
        return Double(correct) / Double(total) * 100
    }
    
    private(set) var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                      return .init(correct: 0, total: 0, date: Date())
                  }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct: Int, total: Int) {
        gamesCount += 1
        accumulateKey(Keys.correct.rawValue, by: correct)
        accumulateKey(Keys.total.rawValue, by: total)
        saveRecord(.init(correct: correct, total: total, date: Date()))
    }
    
    private func accumulateKey(_ key: String, by value: Int) {
        let currentValue = userDefaults.integer(forKey: key)
        userDefaults.set(currentValue + value, forKey: key)
    }
    
    private func saveRecord(_ candidate: GameRecord) {
        if candidate > bestGame {
            bestGame = candidate
        }
    }
}
