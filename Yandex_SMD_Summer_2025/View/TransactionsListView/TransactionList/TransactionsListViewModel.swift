//
//  TransactionsListViewModel.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

@Observable
final class TransactionsListViewModel {
    let direction: Direction
    private let service = TransactionsService()
    
    var transactions: [Transaction] = []
    
    var sumOfTransactions: Decimal = 0
    
    var showEditScreen: Bool = false
    var chosenTransaction: Transaction? = nil
    var editMode: EditMode = .edit
    
    init(direction: Direction) {
        self.direction = direction
    }
    
    func fetchTransactions() async {
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let endOfDay = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
        do {
            transactions = try await service.getTransactionsInDirection(from: startOfDay, to: endOfDay, inDirection: direction)
            sumOfTransactions = countSumOfTransactions()
        } catch {
            fatalError("Error: \(error)") // fatal error сделан специально, чтобы отлавить ошибки на этапе разработке, в прод она не пойдет
        }
    }
    
    private func countSumOfTransactions() -> Decimal {
        return transactions.reduce(0) { result, transaction in
            result + transaction.amount
        }
    }
}
