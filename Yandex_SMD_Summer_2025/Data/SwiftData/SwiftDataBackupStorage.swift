//
//  SwiftDataBackupStorage.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 19.07.2025.
//

import SwiftData
import Foundation

protocol TransactionBackupStorage {
    func fetchAllOperations() async throws -> [BackupOperation]
    func addOperation(_ op: BackupOperation) async throws
    func removeOperation(operationId: UUID) async throws
}

@MainActor
final class SwiftDataBackupStorage: TransactionBackupStorage {
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchAllOperations() async throws -> [BackupOperation] {
        try context.fetch(FetchDescriptor<BackupOperation>())
    }
    
    func addOperation(_ op: BackupOperation) async throws {
        
        context.insert(op)
        
        try await saveContext()
    }
    
    func removeOperation(operationId: UUID) async throws {
        let predicate = #Predicate<BackupOperation> {$0.id == operationId}
        
        try context.delete(model: BackupOperation.self, where: predicate)
        
        try await saveContext()
    }
    
    private func saveContext() async throws {
        try context.save()
    }
}
