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
                switchDirection
                
                listOfCategories
            }
            .background(Color(.secondarySystemBackground))
            .navigationTitle("Мои статьи")
        }
        .tint(.myPurple)
        .searchable(text: $viewModel.searchText)
        .task {
            do {
                try await viewModel.loadCategories()
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    var switchDirection: some View {
        Picker("", selection: $viewModel.direction) {
            ForEach(Direction.allCases) { option in
                Text(option.rawValue).tag(option)
            }
        }
        .onChange(of: viewModel.direction, { oldValue, newValue in
            viewModel.filterCategories()
        })
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
