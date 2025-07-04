//
//  FuzzyModels.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 01.07.2025.
//

import Foundation

struct FuzzySearchCharacter {
    let content: String
    let normalisedContent: String
}

struct FuzzySearchString {
    var characters: [FuzzySearchCharacter]
}

struct FuzzySearchMatchResult {
    let weight: Int
    let matchedParts: [NSRange]
}
