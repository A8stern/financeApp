//
//  extensionBankAccount+Codable.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import Foundation

extension BankAccount: Encodable {
    private enum CodingKeys: String, CodingKey {
        case id, userId, name, balance, currency, createdAt, updatedAt
    }
    
    init(from decoder: any Decoder) throws {
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.name = try container.decode(String.self, forKey: .name)
        let balance = try container.decode(String.self, forKey: .balance)
        self.balance = Decimal(string: balance) ?? 0.0
        self.currency = try container.decode(String.self, forKey: .currency)
        let createdAt = try container.decode(String.self, forKey: .createdAt)
        let updatedAt = try container.decode(String.self, forKey: .updatedAt)
        
        if let date = isoFormatter.date(from: createdAt) {
            self.createdAt = date
        } else {
            throw BankAccountErrors.invalidDateFormat
        }
        
        if let date = isoFormatter.date(from: updatedAt) {
            self.updatedAt = date
        } else {
            throw BankAccountErrors.invalidDateFormat
        }
    }
            
    func encode(to encoder: any Encoder) throws {
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(name, forKey: .name)
        let balance = "\(self.balance)"
        try container.encode(balance, forKey: .balance)
        try container.encode(currency, forKey: .currency)
        try container.encode(isoFormatter.string(from: createdAt), forKey: .createdAt)
        try container.encode(isoFormatter.string(from: updatedAt), forKey: .updatedAt)
    }
}
