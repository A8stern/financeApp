//
//  MyHistoryViewModel.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

enum SortOption: String, CaseIterable, Identifiable {
    case date = "Дате"
    case amount = "Сумме"
    var id: Self { self }
}

final class MyHistoryViewModel: ObservableObject {
    
    var service: TransactionsService
    
    let direction: Direction
    
    @Published var transactions: [Transaction] = []
    @Published var gotTransactions: Bool = false
    
    @Published var sortOption: SortOption = .date
    @Published var showTransactionSection: Bool = false
    
    @Published var sumOfTransactions: Decimal = 0
    
    @Published var startOfPeriod: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    
    @Published var endOfPeriod: Date = Date()
    
    @Published var showEditScreen: Bool = false
    @Published var showAlert: Bool = false
    @Published var localizedError: String = "Неизвестная ошибка"
    @Published var chosenTransaction: Transaction? = nil
    
    init(direction: Direction, service: TransactionsService) {
        self.direction = direction
        self.service = service
        
        Task {
            await fetchTransactions()
        }
    }
    
    func fetchTransactions() async {
        do {
            let newTransactions = try await service.getTransactionsInDirection(from: startOfPeriod, to: endOfPeriod, inDirection: direction)
            sumOfTransactions = countSumOfTransactions(newTransactions)
            sortTransactions(newTransactions)
            gotTransactions = true
        } catch {
            localizedError = error.localizedDescription
            showAlert = true
        }
    }
    
    private func countSumOfTransactions(_ transaction: [Transaction]) -> Decimal {
        return transaction.reduce(0) { result, transactions in
            result + transactions.amount
        }
    }
    
    func sortTransactions(_ transaction: [Transaction]) {
        withAnimation {
            switch sortOption {
            case .date:
                transactions = transaction.sorted { $0.transactionDate < $1.transactionDate }
            case .amount:
                transactions = transaction.sorted { $0.amount < $1.amount }
            }
        }
    }
}
