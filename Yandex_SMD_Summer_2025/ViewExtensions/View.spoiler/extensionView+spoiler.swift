//
//  extensionView+spoiler.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 26.06.2025.
//

import SwiftUI

extension View {

    func spoiler(isOn: Binding<Bool>) -> some View {
        self
            .opacity(isOn.wrappedValue ? 0 : 1)
            .modifier(SpoilerModifier(isOn: isOn.wrappedValue))
            .animation(.default, value: isOn.wrappedValue)
            .onTapGesture {
                isOn.wrappedValue.toggle()
            }
    }
}
