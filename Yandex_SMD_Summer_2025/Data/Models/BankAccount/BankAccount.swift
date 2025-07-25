//
//  BankAccount.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation
import SwiftData

@Model
final class BankAccountEntity: Identifiable {
    @Attribute(.unique)
    var id: Int
    var userId: Int
    var name: String
    var balance: Decimal
    var currency: String
    var createdAt: Date
    var updatedAt: Date
    
    init(id: Int, userId: Int, name: String, balance: Decimal, currency: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.userId = userId
        self.name = name
        self.balance = balance
        self.currency = currency
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(bankAccount: BankAccount) {
        self.id = bankAccount.id
        self.userId = bankAccount.userId
        self.name = bankAccount.name
        self.balance = bankAccount.balance
        self.currency = bankAccount.currency
        self.createdAt = bankAccount.createdAt
        self.updatedAt = bankAccount.updatedAt
    }
}

struct RawBankAccount: Decodable {
    let id: Int
    let userId: Int
    let name: String
    let balance: String
    let currency: String
    let createdAt: String
    let updatedAt: String
}

struct AccountForTransaction: Decodable {
    let id: Int
    let name: String
    let balance: String
    let currency: String
}

struct UpdateAccountRequest: Encodable {
    let name: String
    let balance: String
    let currency: String
}

struct BankAccount: Decodable {
    let id: Int
    let userId: Int
    let name: String
    let balance: Decimal
    let currency: String
    let createdAt: Date
    let updatedAt: Date
    
    init(id: Int, userId: Int, name: String, balance: Decimal, currency: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.userId = userId
        self.name = name
        self.balance = balance
        self.currency = currency
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init(id: Int, userId: Int, name: String, balance: String, currency: String, createdAt: String, updatedAt: String) throws {
        self.id = id
        self.userId = userId
        self.name = name

        guard let balanceDecimal = Decimal(string: balance) else {
            throw BankAccountErrors.invalidBalanceFormat
        }
        self.balance = balanceDecimal

        self.currency = currency

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let createdDate = isoFormatter.date(from: createdAt),
              let updatedDate = isoFormatter.date(from: updatedAt) else {
            throw BankAccountErrors.invalidDateFormat
        }

        self.createdAt = createdDate
        self.updatedAt = updatedDate
    }
    
    init(bankAccount: BankAccountEntity) {
        self.id = bankAccount.id
        self.userId = bankAccount.userId
        self.name = bankAccount.name
        self.balance = bankAccount.balance
        self.currency = bankAccount.currency
        self.createdAt = bankAccount.createdAt
        self.updatedAt = bankAccount.updatedAt
    }
    
    init(fromBackUp: BackupAccount) {
        self.id = fromBackUp.accId
        self.userId = fromBackUp.userId
        self.name = fromBackUp.name
        self.balance = fromBackUp.balance
        self.currency = fromBackUp.currency
        self.createdAt = fromBackUp.createdAt
        self.updatedAt = fromBackUp.updatedAt
    }
    
    init(account: BankAccount, change: Decimal) {
        self.id = account.id
        self.userId = account.userId
        self.name = account.name
        self.balance = account.balance + change
        self.currency = account.currency
        self.createdAt = account.createdAt
        self.updatedAt = account.updatedAt
    }
}
