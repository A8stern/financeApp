//
//  Category.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation
import SwiftData

enum Direction: String, CaseIterable, Identifiable {
    case outcome = "Расходы"
    case income = "Доходы"
    
    var id: Self { self }
}

struct RawCategory: Decodable {
    let id: Int
    let name: String
    let emoji: String
    let isIncome: Bool
}

@Model
final class CategoryEntity: Identifiable {
    @Attribute(.unique)
    var id: Int
    var name: String
    var emoji: String
    var isIncome: Bool
    
    init(id: Int, name: String, emoji: Character, isIncome: Bool) {
        self.id = id
        self.name = name
        self.emoji = String(emoji)
        self.isIncome = isIncome
    }
    
    init(category: Category) {
        self.id = category.id
        self.name = category.name
        self.emoji = String(category.emoji)
        self.isIncome = category.isIncome == .income ? true : false
    }
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
    
    init(categoryEntity: CategoryEntity) {
        self.id = categoryEntity.id
        self.name = categoryEntity.name
        self.emoji = Character(categoryEntity.emoji)
        self.isIncome = categoryEntity.isIncome == true ? .income : .outcome
    }
}
