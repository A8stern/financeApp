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
    
    var body: some View {
        AnalyzeViewControllerRepresentable(direction: direction)
            .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    AnalyzeView(direction: .income)
}
