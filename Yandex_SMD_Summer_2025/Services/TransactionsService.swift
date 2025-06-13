//
//  TransactionsService.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

final class TransactionsService {
    
    private var transactions: [Transaction] = []
    
    init() {
        if let t1 = try? Transaction(
            id: 1,
            accountId: 1,
            categoryId: 2,
            amount: "100.00",
            transactionDate: "2025-06-10T10:00:00.000Z",
            comment: "Магазин",
            createdAt: "2025-06-10T10:00:00.000Z",
            updatedAt: "2025-06-10T10:00:00.000Z"
        ), let t2 = try? Transaction(
            id: 2,
            accountId: 1,
            categoryId: 1,
            amount: "5000.00",
            transactionDate: "2025-06-01T09:00:00.000Z",
            comment: "Зарплата",
            createdAt: "2025-06-01T09:00:00.000Z",
            updatedAt: "2025-06-01T09:00:00.000Z"
        ) {
            transactions = [t1, t2]
        }
    }
    
    func getTransactions(from startDate: Date, to endDate: Date) async throws -> [Transaction] {
        return transactions.filter {
            $0.transactionDate >= startDate && $0.transactionDate <= endDate
        }
    }
    
    func createTransaction(_ transaction: Transaction) async throws {
        guard !transactions.contains(where: { $0.id == transaction.id }) else {
            throw TransactionServiceError.transactionExists
        }
        transactions.append(transaction)
    }
    
    func updateTransaction(_ transaction: Transaction) async throws {
        guard let index = transactions.firstIndex(where: { $0.id == transaction.id }) else {
            throw TransactionServiceError.transactionNotFound
        }
        transactions[index] = transaction
    }
    
    func deleteTransaction(withId id: Int) async throws {
        transactions.removeAll { $0.id == id }
    }
}
