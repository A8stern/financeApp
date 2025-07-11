//
//  AnalyzeViewControllereRepresentable.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 11.07.2025.
//

import SwiftUI

struct AnalyzeViewControllerRepresentable:
    UIViewControllerRepresentable {
    
    let direction: Direction
    
    func makeUIViewController(context: Context) -> AnalyzeViewController {
        return AnalyzeViewController(direction: direction)
    }
    
    func updateUIViewController(_ uiViewController: AnalyzeViewController, context: Context) {
        // Обновления, если нужно
    }
}
