//
//  CostCategoriesView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

struct CostCategoriesView: View {
    
    private enum CostCategoriesMetrics {
        static let circleForIconRadius: CGFloat = 22
        static let paddingHorizontalForPicker: CGFloat = 21
    }
    
    @State
    var viewModel = CostCategoriesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoaded {
                    switchDirection
                    
                    listOfCategories
                } else {
                    ProgressView()
                }
            }
            .alert(viewModel.localizedError, isPresented: $viewModel.showAlert, actions: {
                Button("Закрыть") {
                    viewModel.showAlert = false
                }
            })
            .background(Color(.secondarySystemBackground))
            .navigationTitle("Мои статьи")
        }
        .tint(.myPurple)
        .searchable(text: $viewModel.searchText)
        .task {
            await viewModel.loadCategories()
        }
    }
    
    var switchDirection: some View {
        Picker("", selection: $viewModel.direction) {
            ForEach(Direction.allCases) { option in
                Text(option.rawValue).tag(option)
            }
        }
        .padding(.horizontal, CostCategoriesMetrics.paddingHorizontalForPicker)
        .pickerStyle(.segmented)
    }
    
    var listOfCategories: some View {
        List {
            Section("Статьи") {
                ForEach(viewModel.sortedCategories) { category in
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: CostCategoriesMetrics.circleForIconRadius)
                                .foregroundStyle(Color("LightGreen"))
                            
                            Text("\(category.emoji)")
                                .font(.system(size: 12))
                        }
                        Text(category.name)
                            .font(.system(size: 17))
                    }
                }
            }
        }
    }
}

#Preview {
    CostCategoriesView()
}
