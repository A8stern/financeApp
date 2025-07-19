//
//   BankAccountsService.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

actor BankAccountsService {
    
    func getAccount() async throws -> BankAccount {
        let raw: [RawBankAccount] = try await NetworkClient.shared.request(endpoint: "accounts")
        guard let fetchedAcc = raw.first else {
            throw BankAccountsServiceError.accountNotFound
        }
        let account: BankAccount
        do {
            account = try BankAccount(
                id: fetchedAcc.id,
                userId: fetchedAcc.userId,
                name: fetchedAcc.name,
                balance: fetchedAcc.balance,
                currency: fetchedAcc.currency,
                createdAt: fetchedAcc.createdAt,
                updatedAt: fetchedAcc.updatedAt
            )
        } catch {
            throw BankAccountsServiceError.parsingError
        }
        
        return account
    }
    
    func updateAccount(_ updated: BankAccount) async throws -> BankAccount {
        let requestBody = UpdateAccountRequest(
            name: updated.name,
            balance: updated.balance.description,
            currency: updated.currency
        )
        
        let raw: RawBankAccount = try await NetworkClient.shared.request(
            endpoint: "accounts/\(updated.id)",
            method: .put,
            body: requestBody
        )
        
        let newAccount = try BankAccount(
            id: raw.id,
            userId: raw.userId,
            name: raw.name,
            balance: raw.balance,
            currency: raw.currency,
            createdAt: raw.createdAt,
            updatedAt: raw.updatedAt
        )
        
        return newAccount
    }
}
