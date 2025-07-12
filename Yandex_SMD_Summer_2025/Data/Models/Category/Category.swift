//
//  Category.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

enum Direction: String, CaseIterable, Identifiable {
    case outcome = "Расходы"
    case income = "Доходы"
    
    var id: Self { self }
}

struct Category: Identifiable, Hashable, FuzzySearchable {
    let id: Int
    let name: String
    let emoji: Character
    let isIncome: Direction
    
    var searchableString: String {
        return name
    }
    
    init(id: Int, name: String, emoji: Character, isIncome: Bool) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.isIncome = isIncome ? Direction.income : Direction.outcome
    }
}
