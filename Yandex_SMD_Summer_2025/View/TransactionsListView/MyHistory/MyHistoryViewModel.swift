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

@Observable
final class MyHistoryViewModel {
    
    let direction: Direction
    private let service = TransactionsService()
    
    var transactions: [Transaction] = []
    var gotTransactions: Bool = false
    
    var sortOption: SortOption = .date
    var showTransactionSection: Bool = false
    
    var sumOfTransactions: Decimal = 0
    
    var startOfPeriod: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    
    var endOfPeriod: Date = Date()
    
    var showEditScreen: Bool = false
    var showAlert: Bool = false
    var localizedError: String = "Неизвестная ошибка"
    var chosenTransaction: Transaction? = nil
    
    init(direction: Direction) {
        self.direction = direction
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
