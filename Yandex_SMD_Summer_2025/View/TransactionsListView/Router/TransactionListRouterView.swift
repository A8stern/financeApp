//
//  TransactionListRouterView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

struct TransactionListRouterView<Content: View>: View {
    @StateObject var router: TransactionListRouter = TransactionListRouter()
    private let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: TransactionListRouter.Route.self) { route in
                    router.view(for: route)
                }
        }
        .tint(Color("MyPurple"))
        .environmentObject(router)
    }
}
