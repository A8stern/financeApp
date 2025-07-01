//
//  String+HasPrefix.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 01.07.2025.
//

import Foundation

extension String {
    func lengthOfMatchingPrefix(prefix: FuzzySearchCharacter, startingAt index: Int) -> Int? {
        guard let stringIndex = self.index(self.startIndex, offsetBy: index, limitedBy: self.endIndex) else {
            return nil
        }

        let searchString = self.suffix(from: stringIndex)

        for prefix in [prefix.content, prefix.normalisedContent] where searchString.hasPrefix(prefix) {
            return prefix.count
        }

        return nil
    }
}
