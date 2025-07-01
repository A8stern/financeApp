//
//  FuzzyModels.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 01.07.2025.
//

import Foundation

struct FuzzySearchCharacter {
    let content: String
    // normalised content is referring to a string that is case- and accent-insensitive
    let normalisedContent: String
}

/// FuzzySearchString is just made up by multiple characters
struct FuzzySearchString {
    var characters: [FuzzySearchCharacter]
}

struct FuzzySearchMatchResult {
    let weight: Int
    let matchedParts: [NSRange]
}

class FuzzyCache {
    var hash: Int?
    var lastTokenization = FuzzySearchString(characters: [])
}
