//
//   BankAccountsService.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import SwiftData
import SwiftUI

@MainActor
final class BankAccountsService: ObservableObject {
    
    let swiftDataBankAccountService: SwiftDataBankAccountStorage
    let swiftDataBackUp: SwiftDataAccountBackUpStorage
    var transactionsService: TransactionsService?
    
    init(context: ModelContext) {
        self.swiftDataBankAccountService = SwiftDataBankAccountStorage(context: context)
        self.swiftDataBackUp = SwiftDataAccountBackUpStorage(context: context)
    }
    
    func getAccount() async throws -> BankAccount {
        try await transactionsService?.loadAllDataFromBackup()
        
        do {
            let account = try await getAccountOnline()
            _ = try await updateAccountStorage(account)
            
            return account
        } catch {
            let account = try await getAccountFromStorage()
            
            return account
        }
    }
    
    private func getAccountOnline() async throws -> BankAccount {
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
    
    private func getAccountFromStorage() async throws -> BankAccount {
        let account = try await swiftDataBankAccountService.fetch()
        return account
    }
    
    func updateAccount(_ updated: BankAccount) async throws -> BankAccount {
        try await transactionsService?.loadAllDataFromBackup()
        
        do {
            let acc = try await updateAccountOnline(updated)
            
            _ = try await updateAccountStorage(updated)
            
            return acc
        } catch {
            let newBackupOperation = BackupAccount(bankAccount: updated)
            try await swiftDataBackUp.addOperation(newBackupOperation)
            
            let acc = try await updateAccountStorage(updated)
            
            return acc
        }
    }
    
    func updateAccountOnline(_ updated: BankAccount) async throws -> BankAccount {
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
    
    private func updateAccountStorage(_ updated: BankAccount) async throws -> BankAccount {
        try await swiftDataBankAccountService.updateStorage(updated)
        return updated
    }
}
