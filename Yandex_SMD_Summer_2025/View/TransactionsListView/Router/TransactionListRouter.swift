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
    }
    
    @Published var path: NavigationPath = NavigationPath()
    
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .myHistory(let direction):
            MyHistoryView(direction: direction)
        case .transactionList(let direction):
            TransactionsListView(direction: direction)
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
}
