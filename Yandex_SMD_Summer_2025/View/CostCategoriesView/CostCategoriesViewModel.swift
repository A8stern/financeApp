//
//  CostCategoriesViewModel.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 01.07.2025.
//

import SwiftUI

final class CostCategoriesViewModel: ObservableObject {
    private let service: CategoriesService

    @Published var searchText: String = ""
    @Published var direction: Direction = .outcome
    @Published var isLoaded: Bool = false
    @Published var showAlert: Bool = false
    @Published var localizedError: String = "Неизвестная ошибка"

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
    
    init(service: CategoriesService) {
        self.service = service
    }
    
    func loadCategories() {
        Task { await loadCategoriesAsync() }
    }
    
    private func loadCategoriesAsync() async {
        do {
            isLoaded = false
            let cats = try await service.getCategories()
            allCategories = cats
            isLoaded = true
        } catch {
            localizedError = error.localizedDescription
            showAlert = true
            isLoaded = true
        }
    }
}
