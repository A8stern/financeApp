//
//  TransactionEntity.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 24.07.2025.
//

import Foundation
import SwiftData

@Model
final class TransactionEntity: Identifiable {
    @Attribute(.unique)
    var id: Int
    
    var accId: Int
    var accUserId: Int
    var accName: String
    var accBalance: Decimal
    var accCurrency: String
    var accCreatedAt: Date
    var accUpdatedAt: Date
    
    var catId: Int
    var catName: String
    var catEmoji: String
    var catIsIncome: Bool
    
    var amount: Decimal
    var transactionDate: Date
    var comment: String?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: Int,
        account: BankAccountEntity,
        category: CategoryEntity,
        amount: Decimal,
        transactionDate: Date,
        comment: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        
        self.accId = account.id
        self.accUserId = account.userId
        self.accName = account.name
        self.accBalance = account.balance
        self.accCurrency = account.currency
        self.accCreatedAt = account.createdAt
        self.accUpdatedAt = account.updatedAt
        
        self.catId = category.id
        self.catName = category.name
        self.catEmoji = category.emoji
        self.catIsIncome = category.isIncome
        
        self.amount = amount
        self.transactionDate = transactionDate
        self.comment = comment
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(transaction: Transaction) {
        self.id = transaction.id
        
        self.accId = transaction.account.id
        self.accUserId = transaction.account.userId
        self.accName = transaction.account.name
        self.accBalance = transaction.account.balance
        self.accCurrency = transaction.account.currency
        self.accCreatedAt = transaction.account.createdAt
        self.accUpdatedAt = transaction.account.updatedAt
        
        self.catId = transaction.category.id
        self.catName = transaction.category.name
        self.catEmoji = String(transaction.category.emoji)
        self.catIsIncome = transaction.category.isIncome == .income ? true : false
        
        self.amount = transaction.amount
        self.transactionDate = transaction.transactionDate
        self.comment = transaction.comment
        self.createdAt = transaction.createdAt
        self.updatedAt = transaction.updatedAt
    }
    
    func update(from transaction: Transaction) {
        self.id = transaction.id
        
        self.accId = transaction.account.id
        self.accUserId = transaction.account.userId
        self.accName = transaction.account.name
        self.accBalance = transaction.account.balance
        self.accCurrency = transaction.account.currency
        self.accCreatedAt = transaction.account.createdAt
        self.accUpdatedAt = transaction.account.updatedAt
        
        self.catId = transaction.category.id
        self.catName = transaction.category.name
        self.catEmoji = String(transaction.category.emoji)
        self.catIsIncome = transaction.category.isIncome == .income ? true : false
        
        self.amount = transaction.amount
        self.transactionDate = transaction.transactionDate
        self.comment = transaction.comment
        self.createdAt = transaction.createdAt
        self.updatedAt = transaction.updatedAt
    }
}
