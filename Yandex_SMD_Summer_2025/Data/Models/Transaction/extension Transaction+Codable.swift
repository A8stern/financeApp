//
//  extensionTransaction+Codable.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import Foundation

extension Transaction: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case id, account, category, amount, transactionDate, comment, createdAt, updatedAt
    }
    
    init(from decoder: any Decoder) throws {
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.account = try container.decode(BankAccount.self, forKey: .account)
        self.category = try container.decode(Category.self, forKey: .category)
        let amount = try container.decode(String.self, forKey: .amount)
        self.amount = Decimal(string: amount)!
        self.comment = try container.decode(String?.self, forKey: .comment)
        
        let transactionDate = try container.decode(String.self, forKey: .transactionDate)
        let createdAt = try container.decode(String.self, forKey: .createdAt)
        let updatedAt = try container.decode(String.self, forKey: .updatedAt)
        
        if let date = isoFormatter.date(from: transactionDate) {
            self.transactionDate = date
        } else {
            throw TransactionErrors.invalidDateFormat
        }
        
        if let date = isoFormatter.date(from: createdAt) {
            self.createdAt = date
        } else {
            throw TransactionErrors.invalidDateFormat
        }
        
        if let date = isoFormatter.date(from: updatedAt) {
            self.updatedAt = date
        } else {
            throw TransactionErrors.invalidDateFormat
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        try container.encode(id, forKey: .id)
        try container.encode(account, forKey: .account)
        try container.encode(category, forKey: .category)
        let amount = "\(self.amount)"
        try container.encode(amount, forKey: .amount)
        try container.encode(comment, forKey: .comment)
        try container.encode(isoFormatter.string(from: transactionDate), forKey: .transactionDate)
        try container.encode(isoFormatter.string(from: createdAt), forKey: .createdAt)
        try container.encode(isoFormatter.string(from: updatedAt), forKey: .updatedAt)
        
    }
    
    
}
