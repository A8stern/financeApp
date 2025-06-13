//
//  BankAccount.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

struct BankAccount {
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
}
