//
//  SpoilerModifier.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 26.06.2025.
//

import SwiftUI

struct SpoilerModifier: ViewModifier {

    let isOn: Bool

    func body(content: Content) -> some View {
        content.overlay {
            SpoilerView(isOn: isOn)
        }
    }
}
