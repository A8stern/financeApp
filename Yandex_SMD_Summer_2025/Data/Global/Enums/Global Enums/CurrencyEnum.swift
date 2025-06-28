//
//  CurrencyEnum.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 25.06.2025.
//

import Foundation

enum CurrencyInApp: String, CaseIterable, Identifiable {
    case ruble = "Российский рубль ₽"
    case dollar = "Американский доллар $"
    case euro = "Евро €"
    case didNotLoad = "Не загружено"
    
    var id: String { self.rawValue }
}
