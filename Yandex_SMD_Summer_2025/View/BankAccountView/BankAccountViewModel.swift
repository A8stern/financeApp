//
//  BankAccountViewModel.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 25.06.2025.
//

import SwiftUI

// MARK: VARS

@Observable
final class BankAccountViewModel {
    private let service = BankAccountsService()
    
    private var bankAccount: BankAccount?
    
    var isLoaded: Bool = false
    var showAlert: Bool = false
    var localizedError: String = "Неизвестная ошибка"
    
    var isEditing: Bool = false
    var showCurrencyPicker: Bool = false
    var isBalanceHidden: Bool = false
    
    var selectedCurrency: CurrencyInApp = .didNotLoad
    
    var currencyText: String {
        switch selectedCurrency {
        case .ruble:
            "₽"
        case .dollar:
            "$"
        case .euro:
            "€"
        case .didNotLoad:
            ""
        }
    }
    
    var balanceText: String = "000"
}

// MARK: PRIVATE FUNCS

extension BankAccountViewModel {
    
    private func updateCurrency() {
        guard let account = bankAccount else { return }
        
        switch account.currency {
        case "RUB":
            selectedCurrency = .ruble
        case "USD":
            selectedCurrency = .dollar
        case "EUR":
            selectedCurrency = .euro
        default:
            break
        }
    }
    
    private func saveAccount() async throws {
        if let account = bankAccount {
            let newCurrency: String = switch selectedCurrency {
            case .ruble:
                "RUB"
            case .dollar:
                "USD"
            case .euro:
                "EUR"
            case .didNotLoad:
                account.currency
            }
            do {
                bankAccount = try await service.updateAccount(BankAccount(id: account.id, userId: account.userId, name: account.name, balance: Decimal(string: balanceText) ?? account.balance, currency: newCurrency, createdAt: account.createdAt, updatedAt: Date()))
            } catch {
                localizedError = error.localizedDescription
                showAlert = true
                isLoaded = true
            }
        }
    }
}

// MARK: PUBLIC FUNCS FOR UI

extension BankAccountViewModel {
    func getAccount() async{
        do {
            isLoaded = false
            let newAccount = try await service.getAccount()
            bankAccount = newAccount
            balanceText = "\(newAccount.balance)"
            updateCurrency()
            isLoaded = true
        } catch {
            localizedError = error.localizedDescription
            showAlert = true
            isLoaded = true
        }
    }
    
    func toolBarButtonTapped() {
        if isEditing {
            Task {
                try await saveAccount()
                await getAccount()
                withAnimation {
                    isEditing.toggle()
                }
            }
        } else {
            withAnimation {
                isEditing.toggle()
            }
        }
    }
    
    func currencySectionTapped() {
        if isEditing {
            showCurrencyPicker.toggle()
        }
    }
    
    func refreshValues() {
        Task {
            await getAccount()
        }
    }
    
    func deviceShaken() {
        withAnimation {
            isBalanceHidden.toggle()
        }
    }
    
    func pasteTextFromClipboard() {
        if let text = UIPasteboard.general.string {
            let onlyDigits = text.filter { $0.isNumber }
            if !onlyDigits.isEmpty {
                balanceText = onlyDigits
            }
        }
    }
}
