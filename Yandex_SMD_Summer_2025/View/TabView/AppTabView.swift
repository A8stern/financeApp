//
//  AppTabView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

struct AppTabView: View {
    @EnvironmentObject var categoriesService: CategoriesService
    @EnvironmentObject var bankAccountService: BankAccountsService
    @EnvironmentObject var transactionService: TransactionsService
    
    @State
    var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            TransactionListRouterView(tService: transactionService, cService: categoriesService, bService: bankAccountService, content: {
                TransactionsListView(direction: .outcome, tService: transactionService, bService: bankAccountService, cService: categoriesService)
            })
            .tabItem {
                Image(selection == 0 ? "TransactionOutcomeIconSelected" : "TransactionOutcomeIcon")
                Text("Расходы")
            }
            .tag(0)
            
            TransactionListRouterView(tService: transactionService, cService: categoriesService, bService: bankAccountService, content: {
                TransactionsListView(direction: .income, tService: transactionService, bService: bankAccountService, cService: categoriesService)
            })
            .tabItem {
                Image(selection == 1 ? "TransactionIncomeIconSelected" : "TransactionIncomeIcon")
                Text("Доходы")
            }
            .tag(1)
            
            BankAccountView(service: bankAccountService)
                .tabItem {
                    Image(selection == 2 ? "AccountIconSelected" : "AccountIcon")
                    Text("Счет")
                }
                .environmentObject(bankAccountService)
                .tag(2)
            
            CostCategoriesView(service: categoriesService)
                .tabItem {
                    Image(selection == 3 ? "CostCategoriesIconSelected" : "CostCategoriesIcon")
                    Text("Статьи")
                }
                .environmentObject(categoriesService)
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(selection == 4 ? "SettingsIconSelected" : "SettingsIcon")
                    Text("Настройки")
                }
                .tag(4)
        }
    }
}

#Preview {
    AppTabView()
}
