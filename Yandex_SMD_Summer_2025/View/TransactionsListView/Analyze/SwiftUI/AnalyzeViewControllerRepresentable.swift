//
//  AnalyzeViewControllereRepresentable.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 11.07.2025.
//

import SwiftUI

struct AnalyzeViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var chosenTransaction: Transaction?
    @EnvironmentObject var router: TransactionListRouter
    
    var transactionService: TransactionsService
    
    let direction: Direction

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> AnalyzeViewController {
        let vc = AnalyzeViewController(direction: direction, service: transactionService)
        vc.onTransactionSelect = { tx in
            router.showEdit(
                transaction: tx,
                direction: direction,
                editMode: .edit
            )
        }
        return vc
    }

    func updateUIViewController(_ uiViewController: AnalyzeViewController, context: Context) {
    }

    class Coordinator {
        var parent: AnalyzeViewControllerRepresentable
        init(_ parent: AnalyzeViewControllerRepresentable) {
            self.parent = parent
        }
    }
}
