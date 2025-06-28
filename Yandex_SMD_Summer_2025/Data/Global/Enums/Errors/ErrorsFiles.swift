//
//  ErrorsFiles.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

enum TransactionsFileCacheError: Error {
    case errorSavingToFile(Error)
    case errorTurningToArray
    case fileNotExists
    case unableToAchieveFilesDirectory
}
