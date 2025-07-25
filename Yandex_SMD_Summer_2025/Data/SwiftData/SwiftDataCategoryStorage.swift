//
//  SwiftDataCategoryStorage.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 19.07.2025.
//

import Foundation
import SwiftData

protocol CategoryStorage {
    func fetch() async throws -> [Category]
    func updateStorage(_ categories: [Category]) async throws
}

@MainActor
final class SwiftDataCategoryStorage: CategoryStorage {
    let context: ModelContext
        
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetch() async throws -> [Category] {
        let categories = try context.fetch(FetchDescriptor<CategoryEntity>())
        return categories.map { category in
            Category(categoryEntity: category)
        }
    }
    
    func updateStorage(_ categories: [Category]) async throws {
        let existing = try context.fetch(FetchDescriptor<CategoryEntity>())

        for old in existing where !categories.contains(where: { $0.id == old.id }) {
            context.delete(old)
        }

        for cat in categories {
            if let e = existing.first(where: { $0.id == cat.id }) {
                try await deleteCategory(e)
                try await addCategory(e)
            } else {
                context.insert(CategoryEntity(category: cat))
            }
        }

        try context.save()
    }
    
    private func addCategory(_ category: CategoryEntity) async throws {
        context.insert(category)
    }
    
    private func deleteCategory(_ category: CategoryEntity) async throws {
        context.delete(category)
    }
}
