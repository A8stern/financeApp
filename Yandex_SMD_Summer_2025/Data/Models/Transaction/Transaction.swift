//
//  Transaction.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

struct Transaction {
    let id: Int
    let accountId: Int
    let categoryId: Int
    let amount: Decimal
    let transactionDate: Date
    let comment: String?
    let createdAt: Date
    let updatedAt: Date
    
    init (id: Int, accountId: Int, categoryId: Int, amount: Decimal, transactionDate: Date, comment: String?, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.accountId = accountId
        self.categoryId = categoryId
        self.amount = amount
        self.transactionDate = transactionDate
        self.comment = comment
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(id: Int, accountId: Int, categoryId: Int, amount: String, transactionDate: String, comment: String?, createdAt: String, updatedAt: String) throws {
        self.id = id
        self.accountId = accountId
        self.categoryId = categoryId
        guard let amountOfTransaction = Decimal(string: amount) else {
            throw TransactionErrors.invalidBalanceFormat
        }
        self.amount = amountOfTransaction
        self.comment = comment
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let transactionDateInDate = isoFormatter.date(from: transactionDate),
              let createdDate = isoFormatter.date(from: createdAt),
              let updatedDate = isoFormatter.date(from: updatedAt) else {
            throw TransactionErrors.invalidDateFormat
        }
        self.transactionDate = transactionDateInDate
        self.createdAt = createdDate
        self.updatedAt = updatedDate
    }
}

