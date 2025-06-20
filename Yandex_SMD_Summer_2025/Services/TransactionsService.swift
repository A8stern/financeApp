//
//  TransactionsService.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

actor TransactionsService {
    
    private var transactions: [Transaction] = []
    private let categoriesService = CategoriesService()
    
    init() {
        if let t1 = try? Transaction(
            id: 1,
            account: try BankAccount(
                id: 1,
                userId: 1,
                name: "Основной счёт",
                balance: "1000.00",
                currency: "RUB",
                createdAt: "2025-06-13T08:59:45.854Z",
                updatedAt: "2025-06-13T08:59:45.854Z"
            ),
            category: Category(id: 2, name: "Продукты", emoji: "🛒", isIncome: false),
            amount: "100.00",
            transactionDate: "2025-06-20T10:00:00.000Z",
            comment: "Магазин",
            createdAt: "2025-06-10T10:00:00.000Z",
            updatedAt: "2025-06-10T10:00:00.000Z"
        ), let t2 = try? Transaction(
            id: 2,
            account: try BankAccount(
                id: 1,
                userId: 1,
                name: "Основной счёт",
                balance: "1000.00",
                currency: "RUB",
                createdAt: "2025-06-13T08:59:45.854Z",
                updatedAt: "2025-06-13T08:59:45.854Z"
            ),
            category: Category(id: 1, name: "Зарплата", emoji: "💰", isIncome: true),
            amount: "5000.00",
            transactionDate: "2025-06-20T09:00:00.000Z",
            comment: "Зарплата",
            createdAt: "2025-06-01T09:00:00.000Z",
            updatedAt: "2025-06-01T09:00:00.000Z"
        ), let t3 = try? Transaction(
            id: 3,
            account: try BankAccount(
                id: 1,
                userId: 1,
                name: "Основной счёт",
                balance: "1000.00",
                currency: "RUB",
                createdAt: "2025-06-13T08:59:45.854Z",
                updatedAt: "2025-06-13T08:59:45.854Z"
            ),
            category: Category(id: 1, name: "Зарплата", emoji: "💰", isIncome: true),
            amount: "10000.00",
            transactionDate: "2025-06-19T09:00:00.000Z",
            comment: "Зарплата",
            createdAt: "2025-06-01T09:00:00.000Z",
            updatedAt: "2025-06-01T09:00:00.000Z"
        ) {
            transactions = [t1, t2, t3]
        }
    }
    
    func getTransactions(from startDate: Date, to endDate: Date) throws -> [Transaction] {
        return transactions.filter {
            $0.transactionDate >= startDate && $0.transactionDate <= endDate
        }
    }
    
    func getTransactionsInDirection(from startDate: Date, to endDate: Date, inDirection direction: Direction) async throws -> [Transaction] {
        try? await Task.sleep(for: .seconds(1))
        return transactions.filter {
            $0.transactionDate >= startDate && $0.transactionDate <= endDate && $0.category.isIncome == direction
        }
    }
    
    func getTransactionIcon(withId id: Int) async throws -> Character {
        do {
            let emoji = try await categoriesService.getCategoryById(id).emoji
            return emoji
        } catch {
            throw error
        }
    }
    
    func getTransactionCategoryName(withId id: Int) async throws -> String {
        do {
            let emoji = try await categoriesService.getCategoryById(id).name
            return emoji
        } catch {
            throw error
        }
    }
    
    func createTransaction(_ transaction: Transaction) throws {
        guard !transactions.contains(where: { $0.id == transaction.id }) else {
            throw TransactionServiceError.transactionExists
        }
        transactions.append(transaction)
    }
    
    func updateTransaction(_ transaction: Transaction) throws {
        guard let index = transactions.firstIndex(where: { $0.id == transaction.id }) else {
            throw TransactionServiceError.transactionNotFound
        }
        transactions[index] = transaction
    }
    
    func deleteTransaction(withId id: Int) throws {
        transactions.removeAll { $0.id == id }
    }
}
