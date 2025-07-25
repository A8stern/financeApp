//
//  SwiftDataAccountBackUpStorage.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 25.07.2025.
//

import SwiftData
import Foundation

protocol AccountBackupStorage {
    func fetchAllOperations() async throws -> [BackupAccount]
    func addOperation(_ acc: BackupAccount) async throws
    func removeOperation(operationId: UUID) async throws
}

@MainActor
final class SwiftDataAccountBackUpStorage: AccountBackupStorage {
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchAllOperations() async throws -> [BackupAccount] {
        try context.fetch(FetchDescriptor<BackupAccount>())
    }
    
    func addOperation(_ acc: BackupAccount) async throws {
        
        context.insert(acc)
        
        try await saveContext()
    }
    
    func removeOperation(operationId: UUID) async throws {
        let predicate = #Predicate<BackupAccount> {$0.id == operationId}
        
        try context.delete(model: BackupAccount.self, where: predicate)
        
        try await saveContext()
    }
    
    private func saveContext() async throws {
        try context.save()
    }
}
