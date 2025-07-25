//
//  TransactionsListViewModel.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

@MainActor
final class TransactionsListViewModel: ObservableObject {
    
    var service: TransactionsService
    
    let direction: Direction
    
    @Published var transactions: [Transaction] = []
    
    @Published var gotTransactions: Bool = false
    @Published var showAlert: Bool = false
    @Published var localizedError: String = "Неизвестная ошибка"
    
    @Published var sumOfTransactions: Decimal = 0
    
    @Published var showEditScreen: Bool = false
    @Published var chosenTransaction: Transaction? = nil
    @Published var editMode: EditMode = .edit
    
    init(direction: Direction, service: TransactionsService) {
        self.direction = direction
        self.service = service
    }
    
    func fetchTransactions() async {
        gotTransactions = false
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let endOfDay = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
        do {
            transactions = try await service.getTransactionsInDirection(from: startOfDay, to: endOfDay, inDirection: direction)
            sumOfTransactions = countSumOfTransactions()
            gotTransactions = true
        } catch {
            localizedError = error.localizedDescription
            showAlert = true
        }
    }
    
    private func countSumOfTransactions() -> Decimal {
        return transactions.reduce(0) { result, transaction in
            result + transaction.amount
        }
    }
}
