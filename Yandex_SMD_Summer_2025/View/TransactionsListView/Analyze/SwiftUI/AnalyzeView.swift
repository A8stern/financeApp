//
//  AnalyzeView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 11.07.2025.
//

import SwiftUI

struct AnalyzeView: View {
    let direction: Direction

    @EnvironmentObject var router: TransactionListRouter
    var transactionService: TransactionsService
    
    @State private var chosenTransaction: Transaction? 
    
    init(direction: Direction, transactionService: TransactionsService) {
        self.direction = direction
        self.transactionService = transactionService
    }

    var body: some View {
        AnalyzeViewControllerRepresentable(
            chosenTransaction: $chosenTransaction, transactionService: transactionService,
            direction: direction
        )
        .environmentObject(router)
        .background(Color(.systemGroupedBackground))
    }
}

//#Preview {
//    AnalyzeView(direction: .income)
//}
