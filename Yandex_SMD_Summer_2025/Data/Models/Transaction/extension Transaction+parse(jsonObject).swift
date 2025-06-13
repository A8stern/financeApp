//
//  extension Transaction + parse(jsonObject).swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

extension Transaction {
    static func parse(jsonObject: Any) -> Transaction? {
        guard let dict = jsonObject as? [String: Any],
              let id = dict["id"] as? Int,
              let accountId = dict["accountId"] as? Int,
              let categoryId = dict["categoryId"] as? Int,
              let amount = dict["amount"] as? String,
              let transactionDate = dict["transactionDate"] as? String,
              let createdAt = dict["createdAt"] as? String,
              let updatedAt = dict["updatedAt"] as? String else {
            return nil
        }
        
        let comment = dict["comment"] as? String
        
        return try? Transaction(
            id: id,
            accountId: accountId,
            categoryId: categoryId,
            amount: amount,
            transactionDate: transactionDate,
            comment: comment,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
