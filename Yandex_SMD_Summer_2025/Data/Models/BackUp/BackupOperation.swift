//
//  BackupOperation.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 19.07.2025.
//

import Foundation
import SwiftData

enum ActionType: Codable {
    case create, update, delete
}

@Model
final class BackupOperation {
    @Attribute(.unique)
    var id = UUID()
    
    var transactionId: Int
    
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
    
    var transactionAmount: Decimal
    var transactionDate: Date
    var transactionComment: String?
    var transactionCreatedAt: Date
    var transactionUpdatedAt: Date
    
    var isCreate: Bool
    var isDelete: Bool
    var isUpdate: Bool
    
    var operationTime = Date()
    
    init(transaction: Transaction, action: ActionType) {
        
        self.transactionId = transaction.id
        
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
        
        self.transactionAmount = transaction.amount
        self.transactionDate = transaction.transactionDate
        self.transactionComment = transaction.comment
        self.transactionCreatedAt = transaction.createdAt
        self.transactionUpdatedAt = transaction.updatedAt
        
        switch action {
        case .create:
            self.isCreate = true
            self.isDelete = false
            self.isUpdate = false
        case .update:
            self.isCreate = false
            self.isDelete = false
            self.isUpdate = true
        case .delete:
            self.isCreate = false
            self.isDelete = true
            self.isUpdate = false
        }
        
        self.operationTime = Date()
    }
    
    init(from existing: BackupOperation, newTransactionId: Int) {
        self.transactionId = newTransactionId
        
        self.accId = existing.accId
        self.accUserId = existing.accUserId
        self.accName = existing.accName
        self.accBalance = existing.accBalance
        self.accCurrency = existing.accCurrency
        self.accCreatedAt = existing.accCreatedAt
        self.accUpdatedAt = existing.accUpdatedAt
        
        self.catId = existing.catId
        self.catName = existing.catName
        self.catEmoji = existing.catEmoji
        self.catIsIncome = existing.catIsIncome
        
        self.transactionAmount = existing.transactionAmount
        self.transactionDate = existing.transactionDate
        self.transactionComment = existing.transactionComment
        self.transactionCreatedAt = existing.transactionCreatedAt
        self.transactionUpdatedAt = existing.transactionUpdatedAt
        
        self.isCreate = existing.isCreate
        self.isUpdate = existing.isUpdate
        self.isDelete = existing.isDelete
        
        self.operationTime = existing.operationTime
    }
}
