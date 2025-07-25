//
//  CreateTransactionRequest.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 24.07.2025.
//

import Foundation

struct CreateTransactionRequest: Encodable {
    let accountId: Int
    let categoryId: Int
    let amount: String
    let transactionDate: String
    let comment: String?
}
