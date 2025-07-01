//
//  Collection+fuzzySearch.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 01.07.2025.
//

import Foundation

extension Collection where Iterator.Element: FuzzySearchable {
    func fuzzySearch(query: String) -> [(result: FuzzySearchMatchResult, item: Iterator.Element)] {
        return map {
            (result: $0.fuzzyMatch(query: query), item: $0)
        }.filter {
            $0.result.weight > 0
        }.sorted {
            $0.result.weight > $1.result.weight
        }
    }
}
