//
//  AnalyzeViewModel.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 11.07.2025.
//

import Foundation

final class AnalyzeViewModel {
    
    weak var view: AnalyzeTableViewController?
    
    let direction: Direction
    private let service = TransactionsService()
    
    var transactions: [Transaction] = []
    var sortOption: SortOption = .date
    var showTransactionSection: Bool = false
    
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
            let newTransactions = try await service.getTransactionsInDirection(from: startOfPeriod, to: endOfPeriod, inDirection: direction)
            sumOfTransactions = countSumOfTransactions(newTransactions)
            await sortTransactions(newTransactions)
        } catch {
            fatalError("Error: \(error)") // fatal error сделан специально, чтобы отлавить ошибки на этапе разработке, в прод она не пойдет
        }
    }
    
    func sortTransactions(_ transaction: [Transaction]) async {
        switch sortOption {
        case .date:
            transactions = transaction.sorted { $0.transactionDate < $1.transactionDate }
        case .amount:
            transactions = transaction.sorted { $0.amount < $1.amount }
        }
        await reloadData()
    }
    
    private func countSumOfTransactions(_ transaction: [Transaction]) -> Decimal {
        return transaction.reduce(0) { result, transactions in
            result + transactions.amount
        }
    }
    
    @MainActor
    private func reloadData() {
        Task {
            view?.tableView.reloadData()
        }
    }
}
