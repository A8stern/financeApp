//
//  Transaction.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

struct CreateTransactionRequest: Encodable {
    let accountId: Int
    let categoryId: Int
    let amount: String
    let transactionDate: String
    let comment: String?
}

struct TransactionRaw: Decodable {
    let id: Int
    let accountId: Int
    let categoryId: Int
    let amount: String
    let transactionDate: String
    let comment: String?
    let createdAt: String
    let updatedAt: String
}

struct TransactionListResponse: Decodable {
    let id: Int
    let account: AccountForTransaction
    let category: RawCategory
    let amount: String
    let transactionDate: String
    let comment: String?
    let createdAt: String
    let updatedAt: String
}

struct Transaction: Identifiable {
    let id: Int
    let account: BankAccount
    let category: Category
    let amount: Decimal
    let transactionDate: Date
    let comment: String?
    let createdAt: Date
    let updatedAt: Date
    
    init (id: Int, account: BankAccount, category: Category, amount: Decimal, transactionDate: Date, comment: String?, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.account = account
        self.category = category
        self.amount = amount
        self.transactionDate = transactionDate
        self.comment = comment
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(id: Int, account: BankAccount, category: Category, amount: String, transactionDate: String, comment: String?, createdAt: String, updatedAt: String) throws {
        print(comment)
        self.id = id
        self.account = account
        self.category = category
        
        guard let amountOfTransaction = Decimal(string: amount) else {
            print("⚠️ Invalid amount format: \(amount)")
            throw TransactionErrors.invalidBalanceFormat
        }
        self.amount = amountOfTransaction
        
        if comment == "" {
            self.comment = nil
        } else {
            self.comment = comment
        }
        
        func parseISO(_ string: String) -> Date? {
                    let f = ISO8601DateFormatter()
                    f.timeZone = TimeZone(secondsFromGMT: 0)
                    // Сначала пытаемся с дробной частью
                    f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    if let d = f.date(from: string) { return d }
                    // Потом — без дробной части
                    f.formatOptions = [.withInternetDateTime]
                    return f.date(from: string)
                }

                guard let tDate = parseISO(transactionDate) else {
                    throw TransactionErrors.invalidDateFormat
                }
                guard let cDate = parseISO(createdAt) else {
                    throw TransactionErrors.invalidDateFormat
                }
                guard let uDate = parseISO(updatedAt) else {
                    throw TransactionErrors.invalidDateFormat
                }

                self.transactionDate = tDate
                self.createdAt = cDate
                self.updatedAt = uDate
    }
}

