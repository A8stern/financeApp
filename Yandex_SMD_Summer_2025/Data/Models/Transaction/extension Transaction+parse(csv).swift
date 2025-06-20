//
//  extension Transaction+parse(csv).swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 14.06.2025.
//

import Foundation

extension Transaction {
    static func parseCSV(fromFile filename: String, delimiter: Character = ",") async throws -> [Transaction] {
        guard let dir = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first else {
            throw TransactionErrors.unableToAchieveFilesDirectory
        }
        let url = dir.appendingPathComponent(filename)
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw TransactionErrors.fileNotExists
        }
        
        let csvString: String = try await Task.detached {
            let data = try Data(contentsOf: url)
            guard let s = String(data: data, encoding: .utf8) else {
                throw TransactionErrors.CSVInvalidStringEncoding
            }
            return s
        }.value
        
        return try parse(csv: csvString, delimiter: delimiter)
    }
    
    private static func parse(csv: String, delimiter: Character) throws -> [Transaction] {
        var result: [Transaction] = []
        
        let lines = csv
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        guard lines.count > 1 else { return [] }
        
        for line in lines.dropFirst() {
            let cols = try self.parseLine(for: line, delimiter: delimiter)
            guard cols.count == 8 else {
                throw TransactionErrors.CSVInvalidFieldCount
            }
            
            guard let id = Int(cols[0]),
                  let accountId = Int(cols[1]),
                  let categoryId = Int(cols[2]) else {
                throw TransactionErrors.CSVInvalidIntegerFormat
            }
            
            let amountStr = cols[3]
            let dateStr = cols[4]
            let comment = cols[5].isEmpty ? nil : cols[5]
            let createdAtStr = cols[6]
            let updatedAtStr = cols[7]
            
            let tx = try Transaction(
                id: id,
                account: BankAccount(id: accountId, userId: 1, name: "Vova", balance: "1000", currency: "RUB", createdAt: createdAtStr, updatedAt: updatedAtStr),
                category: Category(id: categoryId, name: "Зарплата", emoji: "😁", isIncome: true),
                amount: amountStr,
                transactionDate: dateStr,
                comment: comment,
                createdAt: createdAtStr,
                updatedAt: updatedAtStr
            )
            result.append(tx)
        }
        
        return result
    }
    
    private static func parseLine(for line: String, delimiter: Character) throws -> [String] {
        var fields: [String] = []
        var cur = ""
        var inQuotes = false
        let chars = Array(line)
        var i = 0
        
        while i < chars.count {
            let c = chars[i]
            if c == "\"" {
                if inQuotes, i+1 < chars.count, chars[i+1] == "\"" {
                    cur.append("\""); i+=1
                } else {
                    inQuotes.toggle()
                }
            }
            else if c == delimiter && !inQuotes {
                fields.append(cur); cur = ""
            }
            else {
                cur.append(c)
            }
            i += 1
        }
        fields.append(cur)
        return fields
    }
}
