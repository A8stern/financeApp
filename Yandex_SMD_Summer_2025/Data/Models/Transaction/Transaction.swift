//
//  Transaction.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

struct Transaction: Identifiable {
    var id: Int
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
        self.id = id
        self.account = account
        self.category = category
        
        guard let amountOfTransaction = Decimal(string: amount) else {
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
            f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let d = f.date(from: string) { return d }
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
    
    init(transactionEntity: TransactionEntity) {
        self.id = transactionEntity.id
        self.account = BankAccount(id: transactionEntity.accId, userId: transactionEntity.accUserId, name: transactionEntity.accName, balance: transactionEntity.accBalance, currency: transactionEntity.accCurrency, createdAt: transactionEntity.accCreatedAt, updatedAt: transactionEntity.accUpdatedAt)
        self.category = Category(id: transactionEntity.catId, name: transactionEntity.catName, emoji: Character(transactionEntity.catEmoji), isIncome: transactionEntity.catIsIncome)
        self.amount = transactionEntity.amount
        self.transactionDate = transactionEntity.transactionDate
        self.comment = transactionEntity.comment
        self.createdAt = transactionEntity.createdAt
        self.updatedAt = transactionEntity.updatedAt
    }
}

