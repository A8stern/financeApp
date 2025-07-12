//
//  AnalyzeViewControllereRepresentable.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 11.07.2025.
//

import SwiftUI

struct AnalyzeViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var chosenTransaction: Transaction?
    let direction: Direction

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> AnalyzeViewController {
        let vc = AnalyzeViewController(direction: direction)
        vc.onTransactionSelect = { tx in
            context.coordinator.parent.chosenTransaction = tx
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
