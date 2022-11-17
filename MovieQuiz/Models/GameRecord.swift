//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 10.11.2022.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

// MARK: - Comparable
extension GameRecord: Comparable {
    static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        lhs.correct < rhs.correct
    }
}
