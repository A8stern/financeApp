//
//  SwiftDataTransactionsStorage.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 19.07.2025.
//

import Foundation
import SwiftData

protocol TransactionsStorage {
    func fetchAll() async throws -> [Transaction]
    func create(_ entity: Transaction) async throws
    func update(_ entity: Transaction) async throws
    func updateStorage(_ entities: [Transaction]) async throws
    func delete(_ entity: Transaction) async throws
}

@MainActor
final class SwiftDataTransactionsStorage: TransactionsStorage {
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() async throws -> [Transaction] {
        let raw = try context.fetch(FetchDescriptor<TransactionEntity>())
        let transactions = raw.map { Transaction(transactionEntity: $0) }
        return transactions
    }

    func create(_ entity: Transaction) async throws {
        let newEntity = TransactionEntity(transaction: entity)
        
        context.insert(newEntity)
        
        try await save()
    }

    func update(_ entity: Transaction) async throws {
        let request = FetchDescriptor<TransactionEntity>(predicate: #Predicate<TransactionEntity> { $0.id == entity.id })
        guard let existing = try context.fetch(request).first else {
            try await create(entity)
            return
        }
        existing.update(from: entity)
    }
    
    func updateStorage(_ entities: [Transaction]) async throws {
        let existingEntities = try context.fetch(FetchDescriptor<TransactionEntity>())

        for tx in entities {
            if existingEntities.contains(where: { $0.id == tx.id }) {
                try await update(tx)
            } else {
                try await create(tx)
            }
        }
        try await save()
    }

    func delete(_ entity: Transaction) async throws {
        let request = FetchDescriptor<TransactionEntity>(predicate: #Predicate<TransactionEntity> { $0.id == entity.id })
        if let toDelete = try context.fetch(request).first {
            context.delete(toDelete)
        }
    }
    
    private func save() async throws {
        try context.save()
    }
}
