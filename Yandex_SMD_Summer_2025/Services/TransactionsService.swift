//
//  TransactionsService.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import SwiftData
import SwiftUI

@MainActor
final class TransactionsService: ObservableObject {
    @AppStorage("lastTempTransactionId") private var lastTempId: Int = 0
    
    init(context: ModelContext, categoryService: CategoriesService, bankAccountService: BankAccountsService) {
        self.categoriesService = categoryService
        self.bankAccountService = bankAccountService
        self.swiftDataBackupService = SwiftDataBackupStorage(context: context)
        self.swiftDataBackupAccountService = SwiftDataAccountBackUpStorage(context: context)
        self.swiftDataTransactionService = SwiftDataTransactionsStorage(context: context)
        self.swiftDataBankAccountService = SwiftDataBankAccountStorage(context: context)
    }
    
    private let swiftDataTransactionService: SwiftDataTransactionsStorage
    private let swiftDataBankAccountService: SwiftDataBankAccountStorage
    private let swiftDataBackupService: SwiftDataBackupStorage
    private let swiftDataBackupAccountService: SwiftDataAccountBackUpStorage
    private let categoriesService: CategoriesService
    private let bankAccountService: BankAccountsService
    
//    private var account: BankAccount?
    private var categories: [Category] = []
    
    private lazy var ready: Task<Void, Error> = Task {
//        let acc  = try await bankAccountService.getAccount()
        let cats = try await categoriesService.getCategories()
//        await self.bootstrap(acc: acc, cats: cats)
        await self.bootstrap(cats: cats)
    }
            
//    private func bootstrap(acc: BankAccount, cats: [Category]) async {
    private func bootstrap(cats: [Category]) async {
//        self.account = acc
        self.categories = cats
    }
    
    func loadAllDataFromBackup() async throws {
        try await ready.value

        var operations = try await swiftDataBackupService.fetchAllOperations()
        var accountOperations = try await swiftDataBackupAccountService.fetchAllOperations()
        
        operations.sort { $0.operationTime < $1.operationTime }
        accountOperations.sort { $0.operationTime < $1.operationTime }
        
        var indexAcc = 0
        var indexTrans = 0
        
        while indexAcc < accountOperations.count || indexTrans < operations.count {
            if indexAcc >= accountOperations.count {
                let leftOperations = operations.filter({$0.operationTime > operations[indexTrans].operationTime})
                let needToReturn = try await tryToBackUpTransaction(operation: operations[indexTrans], leftOperations: leftOperations)
                if needToReturn {
                    return
                }
                indexTrans += 1
            } else if indexTrans >= operations.count {
                try await tryToBackUpAccount(accountFromBackUp: accountOperations[indexAcc])
                indexAcc += 1
            } else if operations[indexTrans].operationTime < accountOperations[indexAcc].operationTime {
                let leftOperations = operations.filter({$0.operationTime > operations[indexTrans].operationTime})
                let needToReturn = try await tryToBackUpTransaction(operation: operations[indexTrans], leftOperations: leftOperations)
                if needToReturn {
                    return
                }
                indexTrans += 1
            } else {
                try await tryToBackUpAccount(accountFromBackUp: accountOperations[indexAcc])
                indexAcc += 1
            }
        }
    }
    
    private func tryToBackUpTransaction(operation: BackupOperation, leftOperations: [BackupOperation]) async throws -> Bool {
        let transaction = Transaction(id: operation.transactionId, account: BankAccount(id: operation.accId, userId: operation.accUserId, name: operation.accName, balance: operation.accBalance, currency: operation.accCurrency, createdAt: operation.accCreatedAt, updatedAt: operation.accUpdatedAt), category: Category(id: operation.catId, name: operation.catName, emoji: Character(operation.catEmoji), isIncome: operation.catIsIncome), amount: operation.transactionAmount, transactionDate: operation.transactionDate, comment: operation.transactionComment, createdAt: operation.transactionCreatedAt, updatedAt: operation.transactionUpdatedAt)
        do {
            if operation.isCreate {
                let newTransaction = try await createTransactionRequest(transaction)
                try await swiftDataTransactionService.delete(transaction)
                try await swiftDataBackupService.removeOperation(operationId: operation.id)
                try await changeOperationsID(from: operation.transactionId, to: newTransaction.id, operations: leftOperations)
                return true
            } else if operation.isUpdate {
                try await updateTransactionRequest(transaction)
            } else if operation.isDelete {
                try await deleteTransactionRequest(withId: transaction.id)
            }

            try await swiftDataBackupService.removeOperation(operationId: operation.id)
            
        } catch {
            print("Ошибка при обработке операции \(operation): \(error)")
        }
        return false
    }
    
    private func changeOperationsID(from oldId: Int, to newId: Int, operations: [BackupOperation]) async throws {
        for operation in operations {
            if operation.transactionId == oldId {
                let newOperation = BackupOperation(from: operation, newTransactionId: newId)
                
                try await swiftDataBackupService.removeOperation(operationId: operation.id)
                try await swiftDataBackupService.addOperation(newOperation)
            }
        }
        
        try await loadAllDataFromBackup()
    }
    
    private func tryToBackUpAccount(accountFromBackUp: BackupAccount) async throws {
        let account = BankAccount(fromBackUp: accountFromBackUp)
        do {
            _ = try await bankAccountService.updateAccountOnline(account)
            try await swiftDataBackupAccountService.removeOperation(operationId: accountFromBackUp.id)
        } catch {
            print("Ошибка при обработке операции \(accountFromBackUp): \(error)")
        }
    }
    
    func getTransactions(from startDate: Date, to endDate: Date) async throws -> [Transaction] {
        try await loadAllDataFromBackup()
        
        do {
            let trans = try await getTransactionsOnline(from: startDate, to: endDate)
            
            return trans
        } catch {
            let trans = try await getTransactionsFromData(from: startDate, to: endDate)
            
            return trans
        }
    }
    
    private func getTransactionsOnline(from startDate: Date, to endDate: Date) async throws -> [Transaction] {
        do {
            try await ready.value
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let startStr = df.string(from: startDate)
            let endStr = df.string(from: endDate)
            
//            guard let acc = account else {
//                throw BankAccountsServiceError.accountNotFound
//            }
            
            let acc = try await bankAccountService.getAccount()
            
            let rawList: [TransactionListResponse] = try await NetworkClient.shared.request(
                endpoint: "transactions/account/\(acc.id)/period?startDate=\(startStr)&endDate=\(endStr)",
                method: .get
            )
            
            let mapped: [Transaction] = try rawList.map { raw in
                guard let cat = categories.first(where: { $0.id == raw.category.id }) else {
                    throw CategoryServiceError.categoryNotFound
                }
                return try Transaction(
                    id: raw.id,
                    account: acc,
                    category: cat,
                    amount: raw.amount,
                    transactionDate: raw.transactionDate,
                    comment: raw.comment,
                    createdAt: raw.createdAt,
                    updatedAt: raw.updatedAt
                )
            }
            
            try await swiftDataTransactionService.updateStorage(mapped)
            
            return mapped
        } catch {
            throw error
        }
    }
    
    private func getTransactionsFromData(from startDate: Date, to endDate: Date) async throws -> [Transaction] {
        let transactions = try await swiftDataTransactionService.fetchAll()
        
        let filteredTransactions = transactions.filter {
            $0.transactionDate >= startDate && $0.transactionDate <= endDate
        }
        
        return filteredTransactions
    }
    
    func getTransactionsInDirection(from startDate: Date, to endDate: Date, inDirection direction: Direction) async throws -> [Transaction] {
        let transactions = try await getTransactions(from: startDate, to: endDate)
        return transactions.filter {
            $0.category.isIncome == direction
        }
    }
    
    func createTransaction(_ transaction: Transaction) async throws {
        var newTransaction = transaction
        do {
            newTransaction = try await createTransactionRequest(transaction)
        } catch {
            newTransaction.id = generateTemporaryOfflineId()
            let newBackupOperation = BackupOperation(transaction: newTransaction, action: .create)
            try await swiftDataBackupService.addOperation(newBackupOperation)
        }
        
        try await swiftDataTransactionService.create(newTransaction)
        
        let fetchedAccount = try await bankAccountService.getAccount()
        
        var change = Decimal(0)
        
        if transaction.category.isIncome == .income {
            change += transaction.amount
        } else {
            change -= transaction.amount
        }
        
        let updatedBankAccount = BankAccount(account: fetchedAccount, change: change)
        try await swiftDataBankAccountService.updateStorage(updatedBankAccount)
    }
    
    private func generateTemporaryOfflineId() -> Int {
        lastTempId -= 1
        return lastTempId
    }
    
    private func createTransactionRequest(_ transaction: Transaction) async throws -> Transaction {
        let isoDate = ISO8601DateFormatter.fullUTC.string(from: transaction.transactionDate)
        
        let amountString = formatAmount(transaction.amount)
        
        let commentString = transaction.comment ?? ""
        
        let requestBody = CreateTransactionRequest(accountId: transaction.account.id, categoryId: transaction.category.id, amount: amountString, transactionDate: isoDate, comment: commentString)
        
//        let dbg = String(data: try JSONEncoder().encode(requestBody), encoding: .utf8)!
        
        let newTransaction: TransactionRaw = try await NetworkClient.shared.request(
            endpoint: "transactions",
            method: .post,
            body: requestBody
        )
        
        var result = transaction
        result.id = newTransaction.id
        
        return result
    }
    
    func updateTransaction(oldTransaction: Transaction, newTransaction: Transaction) async throws {
        do {
            try await updateTransactionRequest(newTransaction)
        } catch {
            let newBackupOperation = BackupOperation(transaction: newTransaction, action: .update)
            try await swiftDataBackupService.addOperation(newBackupOperation)
        }
        
        try await swiftDataTransactionService.update(newTransaction)
        
        let fetchedAccount = try await bankAccountService.getAccount()
        
        var change = Decimal(0)
        
        if newTransaction.category.isIncome == .income {
            change = newTransaction.amount - oldTransaction.amount
        } else {
            change = oldTransaction.amount - newTransaction.amount
        }
        
        let updatedBankAccount = BankAccount(account: fetchedAccount, change: change)
        try await swiftDataBankAccountService.updateStorage(updatedBankAccount)
    }
    
    private func updateTransactionRequest(_ transaction: Transaction) async throws {
        let isoDate = ISO8601DateFormatter.fullUTC.string(from: transaction.transactionDate)
        
        let amountString = formatAmount(transaction.amount)
        
        let commentString = transaction.comment ?? ""
        
        let requestBody = CreateTransactionRequest(accountId: transaction.account.id, categoryId: transaction.category.id, amount: amountString, transactionDate: isoDate, comment: commentString)
        
        let _: TransactionListResponse = try await NetworkClient.shared.request(
            endpoint: "transactions/\(transaction.id)",
            method: .put,
            body: requestBody
        )
    }
    
    func deleteTransaction(_ transaction: Transaction) async throws {
        do {
            try await deleteTransactionRequest(withId: transaction.id)
        } catch {
            let newBackupOperation = BackupOperation(transaction: transaction, action: .delete)
            try await swiftDataBackupService.addOperation(newBackupOperation)
        }
        
        try await swiftDataTransactionService.delete(transaction)
        
        let fetchedAccount = try await bankAccountService.getAccount()
        
        var change = Decimal(0)
        
        if transaction.category.isIncome == .income {
            change -= transaction.amount
        } else {
            change += transaction.amount
        }
        
        let updatedBankAccount = BankAccount(account: fetchedAccount, change: change)
        try await swiftDataBankAccountService.updateStorage(updatedBankAccount)
    }
    
    private func deleteTransactionRequest(withId id: Int) async throws {
        try await NetworkClient.shared.performNoContentRequest(
            endpoint: "transactions/\(id)",
            method: .delete
        )
    }
    
    private func formatAmount(_ value: Decimal) -> String {
        let doubleValue = (value as NSDecimalNumber).doubleValue
        return String(format: "%.2f", doubleValue)
    }
}
