//
//  CostCategoriesViewModel.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 01.07.2025.
//

import SwiftUI

@Observable
final class CostCategoriesViewModel {
    private let service = CategoriesService()

    var searchText: String = ""
    var direction: Direction = .outcome

    private var allCategories: [Category] = []
    var categories: [Category] = []
    
    var sortedCategories: [Category] {
        if searchText.isEmpty {
            return categories
        } else {
            return categories.fuzzySearch(query: searchText).map {
                $0.item
            }
        }
    }

    func loadCategories() async throws {
        allCategories = try await service.getCategories()
        filterCategories()
    }

    func filterCategories() {
        categories = allCategories.filter { $0.isIncome == direction }
    }
}
