//
//  extension Transaction+jsonObject.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

extension Transaction {
    var jsonObject: Any {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        var dict: [String: Any] = [
            "id": id,
            "accountId": accountId,
            "categoryId": categoryId,
            "amount": "\(amount)",
            "transactionDate": isoFormatter.string(from: transactionDate),
            "createdAt": isoFormatter.string(from: createdAt),
            "updatedAt": isoFormatter.string(from: updatedAt)
        ]
        
        if let comment = comment {
            dict["comment"] = comment
        } else {
            dict["comment"] = NSNull()
        }
        
        return dict
    }
}
