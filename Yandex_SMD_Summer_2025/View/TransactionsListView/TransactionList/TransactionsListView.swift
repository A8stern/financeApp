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
    
    init(direction: Direction) {
        self.viewModel = TransactionsListViewModel(direction: direction)
    }
    
    var body: some View {
        ZStack {
            List {
                sumSection
                
                transactionsList
            }
            
            addButton
        }
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
                HStack {
                    ZStack {
                        Circle()
                            .frame(width: 22)
                            .foregroundStyle(Color("LightGreen"))
                        
                        Text("\(transaction.category.emoji)")
                            .font(.system(size: 12))
                    }
                    VStack(alignment: .leading) {
                        Text(transaction.category.name)
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
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13))
                        .foregroundStyle(.tertiary)
                }
                .task {
                    
                }
            }
        }
    }
    
    var addButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Circle()
                    .frame(width: 56)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 27)
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

#Preview {
    TransactionsListView(direction: .income)
}
