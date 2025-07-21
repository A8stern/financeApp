//
//  CategoriesService.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

actor CategoriesService {
    func getCategories() async throws -> [Category] {
        do {
            let rawCategories: [RawCategory] = try await NetworkClient.shared.request(endpoint: "categories")
            return rawCategories.map { raw in
                Category(id: raw.id, name: raw.name, emoji: Character(raw.emoji), isIncome: raw.isIncome)
            }
        } catch {
            throw error
        }
    }
}
