//
//  TransactionsService.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

actor TransactionsService {
    
    private var account: BankAccount?
    private var categories: [Category] = []
    private let categoriesService = CategoriesService()
    private let bankAccountService = BankAccountsService()
    
    private lazy var ready: Task<Void, Error> = Task {
        let acc  = try await bankAccountService.getAccount()
        let cats = try await categoriesService.getCategories()
        await self.bootstrap(acc: acc, cats: cats)
    }
            
    private func bootstrap(acc: BankAccount, cats: [Category]) async {
        self.account = acc
        self.categories = cats
    }
    
    func getTransactions(from startDate: Date, to endDate: Date) async throws -> [Transaction] {
        do {
            try await ready.value
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let startStr = df.string(from: startDate)
            let endStr = df.string(from: endDate)
            
            guard let acc = account else {
                throw BankAccountsServiceError.accountNotFound
            }
            
            let rawList: [TransactionListResponse] = try await NetworkClient.shared.request(
                endpoint: "transactions/account/\(acc.id)/period?startDate=\(startStr)&endDate=\(endStr)",
                method: .get
            )
            
            let mapped: [Transaction] = try rawList.map { raw in
                guard let cat = categories.first(where: { $0.id == raw.category.id }) else {
                    throw CategoryServiceError.categoryNotFound
                }
                return try Transaction(
                    id: raw.id,
                    account: acc,
                    category: cat,
                    amount: raw.amount,
                    transactionDate: raw.transactionDate,
                    comment: raw.comment,
                    createdAt: raw.createdAt,
                    updatedAt: raw.updatedAt
                )
            }
            
            return mapped
        } catch {
            throw error
        }
    }
    
    func getTransactionsInDirection(from startDate: Date, to endDate: Date, inDirection direction: Direction) async throws -> [Transaction] {
        let transactions = try await getTransactions(from: startDate, to: endDate)
        return transactions.filter {
            $0.category.isIncome == direction
        }
    }
    
    func createTransaction(_ transaction: Transaction) async throws {
        let isoDate = ISO8601DateFormatter.fullUTC.string(from: transaction.transactionDate)
        
        let amountString = formatAmount(transaction.amount)
        
        let commentString = transaction.comment ?? ""
        
        let requestBody = CreateTransactionRequest(accountId: transaction.account.id, categoryId: transaction.category.id, amount: amountString, transactionDate: isoDate, comment: commentString)
        
        let dbg = String(data: try JSONEncoder().encode(requestBody), encoding: .utf8)!
        print("→ POST /transactions body:", dbg)
        
        let createdRaw: TransactionRaw = try await NetworkClient.shared.request(
            endpoint: "transactions",
            method: .post,
            body: requestBody
        )
    }
    
    func updateTransaction(_ transaction: Transaction) async throws {
        let isoDate = ISO8601DateFormatter.fullUTC.string(from: transaction.transactionDate)
        
        let amountString = formatAmount(transaction.amount)
        
        let commentString = transaction.comment ?? ""
        
        let requestBody = CreateTransactionRequest(accountId: transaction.account.id, categoryId: transaction.category.id, amount: amountString, transactionDate: isoDate, comment: commentString)
        
        let _: TransactionListResponse = try await NetworkClient.shared.request(
            endpoint: "transactions/\(transaction.id)",
            method: .put,
            body: requestBody
        )
    }
    
    private func formatAmount(_ value: Decimal) -> String {
        // Конвертим в Double и формируем "123.45"
        let doubleValue = (value as NSDecimalNumber).doubleValue
        return String(format: "%.2f", doubleValue)
    }
    
    func deleteTransaction(withId id: Int) async throws {
        try await NetworkClient.shared.performNoContentRequest(
            endpoint: "transactions/\(id)",
            method: .delete
        )
    }
}
