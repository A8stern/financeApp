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
    
    var isLoaded: Bool = false
    var showAlert: Bool = false
    var localizedError: String = "Неизвестная ошибка"
    
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
    
    func loadData() async {
        do {
            isLoaded = false
            try await loadCategories()
            try await loadAccount()
            isLoaded = true
        } catch {
            localizedError = error.localizedDescription
            showAlert = true
            isLoaded = true
        }
    }
    
    private func loadCategories() async throws {
        let categories = try await categoriesService.getCategories()
        allCategories = categories.filter({$0.isIncome == direction})
    }
    
    private func loadAccount() async throws {
        let newAccount = try await accountService.getAccount()
        account = newAccount
        updateCurrency()
    }
    
    func saveOperation() async throws {
        do {
            if mode == .create {
                if let acc = account, let cat = selectedCategory, let amountOfTransaction = Decimal(string: balanceText) {
                    try await transactionService.createTransaction(Transaction(id: 10, account: acc, category: cat, amount: amountOfTransaction, transactionDate: chosenDate, comment: comment == "" ? nil : comment, createdAt: Date(), updatedAt: Date()))
                } else {
                    isLoaded = true
                    localizedError = "Не все поля заполнены"
                    showAlert = true
                }
            } else {
                if let trans = transaction, let cat = selectedCategory, let amountOfTransaction = Decimal(string: balanceText) {
                    try await transactionService.updateTransaction(Transaction(id: trans.id, account: trans.account, category: cat, amount: amountOfTransaction, transactionDate: chosenDate, comment: comment == "" ? nil : comment, createdAt: trans.createdAt, updatedAt: Date()))
                } else {
                    isLoaded = true
                    localizedError = "Не все поля заполнены"
                    showAlert = true
                }
            }
        } catch {
            isLoaded = true
            localizedError = error.localizedDescription
            showAlert = true
        }
    }
    
    func deleteOperation() async throws {
        do {
            if let trans = transaction {
                try await transactionService.deleteTransaction(withId: trans.id)
            }
        } catch {
            isLoaded = true
            localizedError = error.localizedDescription
            showAlert = true
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
        print(balanceText)
        print(selectedCategory ?? "Not selected")
        showAlert.toggle()
    }
}

