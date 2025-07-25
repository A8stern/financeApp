//
//  TransactionListRouterView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

struct TransactionListRouterView<Content: View>: View {
    @StateObject var router: TransactionListRouter
    
    var transactionService: TransactionsService
    var categoriesService: CategoriesService
    var bankAccountService: BankAccountsService
    
    private let content: Content
    
    init(tService: TransactionsService, cService: CategoriesService, bService: BankAccountsService, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        _router = StateObject(wrappedValue: TransactionListRouter(transactionService: tService, categoriesService: cService, bankAccountService: bService))
        self.transactionService = tService
        self.categoriesService = cService
        self.bankAccountService = bService
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: TransactionListRouter.Route.self) { route in
                    router.view(for: route)
                }
                .fullScreenCover(item: $router.chosenTransaction) { tx in
                    EditCreateView(
                        direction: router.direction,
                        mode: .edit,
                        transaction: tx,
                        transactionService: transactionService,
                        categoriesService: categoriesService,
                        bankAccountService: bankAccountService
                    )
                }
        }
        .tint(Color("MyPurple"))
        .environmentObject(router)
    }
}
