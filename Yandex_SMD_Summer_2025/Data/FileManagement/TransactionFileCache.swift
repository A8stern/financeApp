//
//  TransactionFileCache.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

final class TransactionsFileCache {
    private(set) var transactions: [Transaction] = []

    func add(_ transaction: Transaction) {
        guard !transactions.contains(where: { $0.id == transaction.id }) else { return }
        transactions.append(transaction)
    }

    func remove(byId id: Int) {
        transactions.removeAll(where: { $0.id == id })
    }

    func save(to filename: String) async throws {
        let url = try getFileURL(filename: filename)
        
        let jsonObjects = try transactions.map { try $0.jsonObject }
        let jsonData = try JSONSerialization.data(withJSONObject: jsonObjects, options: [.prettyPrinted])
        
        try await Task.detached {
            try jsonData.write(to: url, options: .atomic)
        }.value
    }

    func load(from filename: String) async throws {
        let url = try getFileURL(filename: filename)
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw TransactionsFileCacheError.fileNotExists
        }
        
        let loadedTransactions: [Transaction] = try await Task.detached {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data)
            
            guard let array = json as? [Any] else {
                return []
            }
            
            return array.compactMap { Transaction.parse(jsonObject: $0) }
        }.value
        
        var seenIDs = Set<Int>()
        self.transactions = loadedTransactions.filter { seenIDs.insert($0.id).inserted }
    }

    private func getFileURL(filename: String) throws -> URL {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw TransactionsFileCacheError.unableToAchieveFilesDirectory
        }
        return dir.appendingPathComponent(filename)
    }
}
