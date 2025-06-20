//
//  extension Transaction+jsonObject.swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

extension Transaction {
    var jsonObject: Any {
        get throws {
            let data = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: data)
        }
    }
}
