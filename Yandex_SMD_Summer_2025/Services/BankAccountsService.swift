//
//   BankAccountsService.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

actor BankAccountsService {
    
    private var storedAccount: BankAccount?
    
    init() {
        do {
            self.storedAccount = try BankAccount(
                id: 1,
                userId: 1,
                name: "Основной счёт",
                balance: "1000.00",
                currency: "RUB",
                createdAt: "2025-06-13T08:59:45.854Z",
                updatedAt: "2025-06-13T08:59:45.854Z"
            )
        } catch {
            print("Error in mock bank account service: \(error)")
        }
    }
    
    func getAccount() throws -> BankAccount {
        guard let storedAccount else {
            throw BankAccountsServiceError.accountNotFound
        }
        return storedAccount
    }
    
    func updateAccount(to updated: BankAccount) throws {
        self.storedAccount = updated
    }
}
