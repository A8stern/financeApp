//
//  AppTabView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

struct AppTabView: View {
    
    @State
    var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            TransactionListRouterView {
                TransactionsListView(direction: .outcome)
            }
                .tabItem {
                    Image(selection == 0 ? "TransactionOutcomeIconSelected" : "TransactionOutcomeIcon")
                    Text("Расходы")
                }
                .tag(0)
            
            TransactionListRouterView {
                TransactionsListView(direction: .income)
            }
                .tabItem {
                    Image(selection == 1 ? "TransactionIncomeIconSelected" : "TransactionIncomeIcon")
                    Text("Доходы")
                }
                .tag(1)
            
            BankAccountView()
                .tabItem {
                    Image(selection == 2 ? "AccountIconSelected" : "AccountIcon")
                    Text("Счет")
                }
                .tag(2)
            
            CostCategoriesView()
                .tabItem {
                    Image(selection == 3 ? "CostCategoriesIconSelected" : "CostCategoriesIcon")
                    Text("Статьи")
                }
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
