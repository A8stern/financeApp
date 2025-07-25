//
//  TransactionListResponse.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 24.07.2025.
//

import Foundation

struct TransactionListResponse: Decodable {
    let id: Int
    let account: AccountForTransaction
    let category: RawCategory
    let amount: String
    let transactionDate: String
    let comment: String?
    let createdAt: String
    let updatedAt: String
}
