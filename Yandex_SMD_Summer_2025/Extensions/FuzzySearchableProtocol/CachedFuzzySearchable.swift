//
//  CachedFuzzySearchable.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 01.07.2025.
//

import Foundation

struct CachedFuzzySearchable<T>: FuzzySearchable where T: FuzzySearchable {
    let wrappedSearchable: T
    let fuzzySearchCache: FuzzyCache

    init(wrapping searchable: T) {
        self.wrappedSearchable = searchable
        self.fuzzySearchCache = FuzzyCache()
    }

    public var searchableString: String {
        return wrappedSearchable.searchableString
    }

    func tokenizeString() -> FuzzySearchString {
        if fuzzySearchCache.hash == nil || fuzzySearchCache.hash != searchableString.hashValue {
            let characters = searchableString.normalise()
            fuzzySearchCache.hash = searchableString.hashValue
            fuzzySearchCache.lastTokenization = FuzzySearchString(characters: characters)
        }

        return fuzzySearchCache.lastTokenization
    }
}
