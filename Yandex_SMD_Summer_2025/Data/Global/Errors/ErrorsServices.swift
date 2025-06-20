//
//  ErrorsServices.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

enum TransactionServiceError: Error {
    case transactionNotFound
    case transactionExists
}

enum BankAccountsServiceError: Error {
    case accountNotFound
}

enum CategoryServiceError: Error {
    case categoryNotFound
}
