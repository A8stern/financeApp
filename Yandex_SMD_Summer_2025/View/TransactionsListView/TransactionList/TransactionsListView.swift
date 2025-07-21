//
//  TransactionsListView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

struct TransactionsListView: View {
    
    @State
    var viewModel: TransactionsListViewModel
    
    @EnvironmentObject var router: TransactionListRouter
    
    private enum TransactionListMetrics {
        static let circleForIconRadius: CGFloat = 22
        static let addButtonFrameWidth: CGFloat = 56
        static let addButtonHorizontalPadding: CGFloat = 16
        static let addButtonVerticalPadding: CGFloat  = 27
    }
    
    init(direction: Direction) {
        self.viewModel = TransactionsListViewModel(direction: direction)
    }
    
    var body: some View {
        ZStack {
            List {
                sumSection
                
                if viewModel.gotTransactions {
                    transactionsList
                } else {
                    ProgressView()
                }
            }
            
            addButton
        }
        .alert(viewModel.localizedError, isPresented: $viewModel.showAlert, actions: {
            Button("Закрыть") {
                viewModel.showAlert = false
            }
        })
        .fullScreenCover(isPresented: $viewModel.showEditScreen, onDismiss: {
            Task {
                await viewModel.fetchTransactions()
            }
        }, content: {
            if viewModel.editMode == .edit {
                EditCreateView(direction: viewModel.direction, mode: .edit, transaction: viewModel.chosenTransaction)
            } else {
                EditCreateView(direction: viewModel.direction, mode: .create, transaction: nil)
            }
        })
        .navigationTitle(viewModel.direction == .outcome ? "Расходы" : "Доходы")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.navigateTo(.myHistory(viewModel.direction))
                } label: {
                    Image(systemName: "clock")
                }
            }
        }
        .task {
            await viewModel.fetchTransactions()
        }
    }
    
    var sumSection: some View {
        Section {
            HStack {
                Text("Всего")
                Spacer()
                Text("\(viewModel.sumOfTransactions) ₽")
            }
        }
    }
    
    var transactionsList: some View {
        Section("Операции") {
            ForEach(viewModel.transactions) { transaction in
                Button {
                    viewModel.editMode = .edit
                    viewModel.showEditScreen = true
                    viewModel.chosenTransaction = transaction
                } label: {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: TransactionListMetrics.circleForIconRadius)
                                .foregroundStyle(Color("LightGreen"))
                            
                            Text("\(transaction.category.emoji)")
                                .font(.system(size: 12))
                        }
                        VStack(alignment: .leading) {
                            Text(transaction.category.name)
                                .foregroundStyle(.black)
                                .font(.system(size: 17))
                            if let secondText = transaction.comment {
                                Text(secondText)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Text("\(transaction.amount) ₽")
                            .font(.system(size: 17))
                            .foregroundStyle(.black)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13))
                            .foregroundStyle(.tertiary)
                    }
                }
            }
        }
    }
    
    var addButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    viewModel.editMode = .create
                    viewModel.showEditScreen = true
                } label: {
                    Circle()
                        .frame(width: TransactionListMetrics.addButtonFrameWidth)
                        .padding(.horizontal, TransactionListMetrics.addButtonHorizontalPadding)
                        .padding(.vertical, TransactionListMetrics.addButtonVerticalPadding)
                        .foregroundStyle(Color("AccentColor"))
                        .overlay {
                            Image(systemName: "plus")
                                .foregroundStyle(Color.white)
                                .font(.title)
                        }
                }
            }
        }
    }
}

#Preview {
    TransactionsListView(direction: .income)
}
