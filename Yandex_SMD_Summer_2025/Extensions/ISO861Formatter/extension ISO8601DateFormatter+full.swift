//
//  extension ISO8601DateFormatter+full.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 19.07.2025.
//

import Foundation

extension ISO8601DateFormatter {
    static let fullUTC: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        f.timeZone = TimeZone(secondsFromGMT: 0)
        return f
    }()
}
