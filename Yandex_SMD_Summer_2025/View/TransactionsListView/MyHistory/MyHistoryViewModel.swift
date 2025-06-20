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
    var sortOption: SortOption = .date
    
    var sumOfTransactions: Decimal = 0
    
    var startOfPeriod: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    
    var endOfPeriod: Date = Date()
    
    init(direction: Direction) {
        self.direction = direction
        Task {
            await fetchTransactions()
        }
    }
    
    func fetchTransactions() async {
        do {
            transactions = try await service.getTransactionsInDirection(from: startOfPeriod, to: endOfPeriod, inDirection: direction)
            sumOfTransactions = countSumOfTransactions()
            sortTransactions()
        } catch {
            fatalError("Error: \(error)") // fatal error сделан специально, чтобы отлавить ошибки на этапе разработке, в прод она не пойдет
        }
    }
    
    private func countSumOfTransactions() -> Decimal {
        return transactions.reduce(0) { result, transaction in
            result + transaction.amount
        }
    }
    
    func sortTransactions() {
        switch sortOption {
        case .date:
            transactions = transactions.sorted { $0.transactionDate < $1.transactionDate }
        case .amount:
            transactions = transactions.sorted { $0.amount < $1.amount }
        }
    }
}
