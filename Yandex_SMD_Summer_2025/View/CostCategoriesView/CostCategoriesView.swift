//
//  CostCategoriesView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

struct CostCategoriesView: View {
    
    @StateObject private var viewModel: CostCategoriesViewModel

    init(service: CategoriesService) {
        _viewModel = StateObject(
            wrappedValue: CostCategoriesViewModel(service: service)
        )
    }

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoaded {
                    directionPicker
                    categoryList
                } else {
                    ProgressView()
                }
            }
            .searchable(text: $viewModel.searchText)
            .alert(viewModel.localizedError, isPresented: $viewModel.showAlert) {
                Button("Закрыть", role: .cancel) { }
            }
            .navigationTitle("Мои статьи")
            .background(Color(.secondarySystemBackground))
            .task {
                viewModel.loadCategories()
            }
        }
        .tint(.myPurple)
    }

    private var directionPicker: some View {
        Picker("", selection: $viewModel.direction) {
            ForEach(Direction.allCases) { dir in
                Text(dir.rawValue).tag(dir)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, 21)
    }
    
    private var categoryList: some View {
        List {
            Section("Статьи") {
                ForEach(viewModel.sortedCategories) { category in
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 22)
                                .foregroundStyle(Color("LightGreen"))
                            Text(String(category.emoji))
                                .font(.system(size: 12))
                        }
                        Text(category.name)
                            .font(.system(size: 17))
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

//#Preview {
//    // Для превью просто создаём сервис-заглушку
//    CostCategoriesView(service: .init(context: .init(for: .preview)))
//        .environmentObject(CategoriesService(context: .init(for: .preview)))
//}
