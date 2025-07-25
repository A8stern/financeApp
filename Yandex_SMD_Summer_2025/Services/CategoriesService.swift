//
//  CategoriesService.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import SwiftData
import SwiftUI

@MainActor
final class CategoriesService: ObservableObject {
    
    init(context: ModelContext) {
        self.swiftDataService = SwiftDataCategoryStorage(context: context)
    }
    
    let swiftDataService: SwiftDataCategoryStorage
    
    func getCategories() async throws -> [Category] {
        do {
            let rawCategories: [RawCategory] = try await NetworkClient.shared.request(endpoint: "categories")
            let fetchedCategories = rawCategories.map { raw in
                Category(id: raw.id, name: raw.name, emoji: Character(raw.emoji), isIncome: raw.isIncome)
            }
            try await swiftDataService.updateStorage(fetchedCategories)
            return fetchedCategories
        } catch {
            do {
                let localCategories = try await swiftDataService.fetch()
                return localCategories
            } catch {
                throw error
            }
        }
    }
}
