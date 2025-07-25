//
//  SwiftDataBankAccountStorage.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 23.07.2025.
//

import Foundation
import SwiftData

protocol AccountStorage {
    func fetch() async throws -> BankAccount
    func updateStorage(_ account: BankAccount) async throws
}

@MainActor
final class SwiftDataBankAccountStorage: AccountStorage {
    let context: ModelContext
        
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetch() async throws -> BankAccount {
        guard let newAccount = try context.fetch(FetchDescriptor<BankAccountEntity>()).first else {
            throw BankAccountsServiceError.accountNotFound
        }
        let fetchedAccount = BankAccount(bankAccount: newAccount)
        return fetchedAccount
    }
    
    func updateStorage(_ account: BankAccount) async throws {
        let request = FetchDescriptor<BankAccountEntity>()
        let existing = try context.fetch(request)
        
        let newEntity = BankAccountEntity(bankAccount: account)
        
        if let e = existing.first {
            try await deleteAccount(e)
            try await addAccount(newEntity)
        } else {
            context.insert(BankAccountEntity(bankAccount: account))
        }
    }
    
    private func addAccount(_ acc: BankAccountEntity) async throws {
        context.insert(acc)
    }
    
    private func deleteAccount(_ acc: BankAccountEntity) async throws {
        context.delete(acc)
    }
}
