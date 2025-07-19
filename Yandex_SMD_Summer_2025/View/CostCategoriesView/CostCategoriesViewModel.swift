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
    private var filteredCategories: [Category] {
        return allCategories.filter { $0.isIncome == direction }
    }
    
    var sortedCategories: [Category] {
        if searchText.isEmpty {
            return filteredCategories
        } else {
            return filteredCategories.fuzzySearch(query: searchText).map {
                $0.item
            }
        }
    }
    
    var isLoaded: Bool = false
    var showAlert: Bool = false
    var localizedError: String = "Неизвестная ошибка"

    func loadCategories() async {
        do {
            isLoaded = false
            allCategories = try await service.getCategories()
            isLoaded = true
        } catch {
            localizedError = error.localizedDescription
            showAlert = true
            isLoaded = true
        }
    }
}
