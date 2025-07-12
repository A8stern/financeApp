//
//  EditSaveViewModel.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 12.07.2025.
//

import SwiftUI

@Observable
final class EditCreateViewModel {
    
    let direction: Direction
    let mode: EditMode
    
    private let transactionService = TransactionsService()
    private let categoriesService = CategoriesService()
    private let accountService = BankAccountsService()
    
    var transaction: Transaction?
    
    var allCategories: [Category] = []
    var selectedCategory: Category?
    
    var balanceText: String = ""
    
    var chosenDate: Date = Date()
    
    var comment: String = ""
    
    var account: BankAccount?
    var currencyText: String = "₽"
    
    var showAlert: Bool = false
    
    init(direction: Direction, editMode: EditMode, transaction: Transaction?) {
        self.direction = direction
        self.mode = editMode
        if let trans = transaction {
            self.transaction = trans
            self.selectedCategory = trans.category
            self.balanceText = "\(trans.amount)"
            self.chosenDate = trans.transactionDate
            self.comment = trans.comment ?? ""
        }
    }
    
    func loadCategories() async throws {
        let categories = try await categoriesService.getCategories()
        allCategories = categories.filter({$0.isIncome == direction})
    }
    
    func saveOperation() async throws {
        do {
            if mode == .create {
                if let acc = account, let cat = selectedCategory, let amountOfTransaction = Decimal(string: balanceText) {
                    try await transactionService.createTransaction(Transaction(id: 10, account: acc, category: cat, amount: amountOfTransaction, transactionDate: chosenDate, comment: comment == "" ? nil : comment, createdAt: Date(), updatedAt: Date()))
                } else {
                    throw SaveCreateViewError.notAllFieldsFilled
                }
            } else {
                if let trans = transaction, let cat = selectedCategory, let amountOfTransaction = Decimal(string: balanceText) {
                    try await transactionService.updateTransaction(Transaction(id: trans.id, account: trans.account, category: cat, amount: amountOfTransaction, transactionDate: chosenDate, comment: comment == "" ? nil : comment, createdAt: trans.createdAt, updatedAt: Date()))
                } else {
                    throw SaveCreateViewError.notAllFieldsFilled
                }
            }
        } catch {
            throw error
        }
    }
    
    func deleteOperation() async throws {
        do {
            if let trans = transaction {
                try await transactionService.deleteTransaction(withId: trans.id)
            }
        } catch {
            throw error
        }
    }
    
    private func loadAccount() {
        Task {
            do {
                let newAccount = try await accountService.getAccount()
                account = newAccount
                updateCurrency()
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func updateCurrency() {
        guard let account = account else { return }
        
        switch account.currency {
        case "RUB":
            currencyText = "₽"
        case "USD":
            currencyText = "$"
        case "EUR":
            currencyText = "€"
        default:
            break
        }
    }
    
    func toggleAlert() {
        showAlert.toggle()
    }
}

