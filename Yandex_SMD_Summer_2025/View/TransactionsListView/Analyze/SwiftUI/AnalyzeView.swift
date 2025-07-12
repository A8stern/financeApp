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

    @State private var chosenTransaction: Transaction?

    var body: some View {
        AnalyzeViewControllerRepresentable(
            chosenTransaction: $chosenTransaction,
            direction: direction
        )
        .background(Color(.systemGroupedBackground))
        .fullScreenCover(item: $chosenTransaction) { tx in
            EditCreateView(
                direction: direction,
                mode: .edit,
                transaction: tx
            )
        }
    }
}

#Preview {
    AnalyzeView(direction: .income)
}
