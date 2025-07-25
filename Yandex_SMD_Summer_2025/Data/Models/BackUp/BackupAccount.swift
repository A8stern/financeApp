//
//  BackupAccount.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 25.07.2025.
//

import Foundation
import SwiftData

@Model
final class BackupAccount {
    @Attribute(.unique)
    var id = UUID()
    
    var accId: Int
    var userId: Int
    var name: String
    var balance: Decimal
    var currency: String
    var createdAt: Date
    var updatedAt: Date
    
    var operationTime = Date()
    
    init(bankAccount: BankAccount) {
        self.accId = bankAccount.id
        self.userId = bankAccount.userId
        self.name = bankAccount.name
        self.balance = bankAccount.balance
        self.currency = bankAccount.currency
        self.createdAt = bankAccount.createdAt
        self.updatedAt = bankAccount.updatedAt
    }
}
