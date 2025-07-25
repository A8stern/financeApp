//
//  TransactionRaw.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 24.07.2025.
//

import Foundation

struct TransactionRaw: Decodable {
    let id: Int
    let accountId: Int
    let categoryId: Int
    let amount: String
    let transactionDate: String
    let comment: String?
    let createdAt: String
    let updatedAt: String
}
