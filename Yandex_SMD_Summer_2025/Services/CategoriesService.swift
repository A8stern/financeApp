//
//  CategoriesService.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

final class CategoriesService {
    
    private let mockCategories: [Category] = [
        Category(id: 1, name: "Зарплата", emoji: "💰", isIncome: true),
        Category(id: 2, name: "Продукты", emoji: "🛒", isIncome: false),
        Category(id: 3, name: "Подарок", emoji: "🎁", isIncome: true),
        Category(id: 4, name: "Транспорт", emoji: "🚗", isIncome: false),
        Category(id: 5, name: "Фриланс", emoji: "🖥", isIncome: true),
        Category(id: 6, name: "Развлечения", emoji: "🎮", isIncome: false)
    ]
    
    func categories() async throws -> [Category] {
        return mockCategories
    }
    
    func categories(direction: Direction) async throws -> [Category] {
        return mockCategories.filter { $0.isIncome == direction }
    }
}
