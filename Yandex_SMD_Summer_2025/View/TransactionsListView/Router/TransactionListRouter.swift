//
//  TransactionListRouter.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

class TransactionListRouter: ObservableObject {
    
    enum Route: Hashable {
        case myHistory(Direction)
        case transactionList(Direction)
        case analyze(Direction)
    }
    
    @Published var path: NavigationPath = NavigationPath()
    
    @Published var chosenTransaction: Transaction?
    @Published var direction: Direction = .outcome
    @Published var editMode: EditMode = .edit
    
    var transactionService: TransactionsService
    var categoriesService: CategoriesService
    var bankAccountService: BankAccountsService
    
    init(transactionService: TransactionsService, categoriesService: CategoriesService, bankAccountService: BankAccountsService) {
        self.transactionService = transactionService
        self.categoriesService = categoriesService
        self.bankAccountService = bankAccountService
    }
    
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .myHistory(let direction):
            MyHistoryView(direction: direction, tService: transactionService, bService: bankAccountService, cService: categoriesService)
        case .transactionList(let direction):
            TransactionsListView(direction: direction, tService: transactionService, bService: bankAccountService, cService: categoriesService)
        case .analyze(let direction):
            AnalyzeView(direction: direction, transactionService: transactionService)
        }
    }
    
    func navigateTo(_ appRoute: Route) {
        path.append(appRoute)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func showEdit(transaction: Transaction, direction: Direction, editMode: EditMode) {
        self.editMode = editMode
        self.direction = direction
        self.chosenTransaction = transaction
    }
}
