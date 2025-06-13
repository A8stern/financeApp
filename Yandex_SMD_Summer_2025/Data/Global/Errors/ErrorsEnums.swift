//
//  ErrorsEnums.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

enum TransactionErrors: Error {
    case invalidBalanceFormat
    case invalidDateFormat
    case CSVInvalidFieldCount
    case CSVInvalidIntegerFormat
    case CSVInvalidStringEncoding
    case fileNotExists
    case unableToAchieveFilesDirectory
}

enum BankAccountErrors: Error {
    case invalidBalanceFormat
    case invalidDateFormat
}
