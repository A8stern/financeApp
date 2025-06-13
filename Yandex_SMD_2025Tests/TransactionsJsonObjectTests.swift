//
//  Yandex_SMD_2025Tests.swift
//  Yandex_SMD_2025Tests
//
//  Created by Kovalev Gleb on 14.06.2025.
//

import Foundation
import Testing

@testable import Yandex_SMD_Summer_2025

struct TransactionsJsonObjectTests {

    @Test func testJsonObjectAndParse_withComment() throws {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let now = Date()
        let later = now.addingTimeInterval(60)

        let tx = try Transaction(
            id: 1,
            accountId: 1,
            categoryId: 1,
            amount: "1000",
            transactionDate: isoFormatter.string(from: now),
            comment: "Test comment",
            createdAt: isoFormatter.string(from: now),
            updatedAt: isoFormatter.string(from: later)
        )

        let obj = tx.jsonObject
        #expect(obj is [String: Any])

        let dict = obj as! [String: Any]
        #expect(dict["id"] as? Int == 1)
        #expect(dict["accountId"] as? Int == 1)
        #expect(dict["categoryId"] as? Int == 1)
        #expect(dict["amount"] as? String == "1000")
        #expect(dict["transactionDate"] as? String == isoFormatter.string(from: now))
        #expect(dict["createdAt"] as? String == isoFormatter.string(from: now))
        #expect(dict["updatedAt"] as? String == isoFormatter.string(from: later))
        #expect(dict["comment"] as? String == "Test comment")

        #expect(Transaction.parse(jsonObject: obj) != nil)
        let parsed = Transaction.parse(jsonObject: obj)!

        #expect(parsed.id == tx.id)
        #expect(parsed.accountId == tx.accountId)
        #expect(parsed.categoryId == tx.categoryId)
        #expect(parsed.amount == tx.amount)
        #expect(parsed.transactionDate == tx.transactionDate)
        #expect(parsed.createdAt == tx.createdAt)
        #expect(parsed.updatedAt == tx.updatedAt)
        #expect(parsed.comment == tx.comment)
    }

    @Test func testJsonObjectAndParse_withoutComment() throws {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let now = Date()

        let tx = try Transaction(
            id: 1,
            accountId: 1,
            categoryId: 1,
            amount: "1000",
            transactionDate: isoFormatter.string(from: now),
            comment: nil,
            createdAt: isoFormatter.string(from: now),
            updatedAt: isoFormatter.string(from: now)
        )

        let obj = tx.jsonObject
        #expect(obj is [String: Any])

        let dict = obj as! [String: Any]
        #expect(dict["comment"] is NSNull)

        #expect(Transaction.parse(jsonObject: obj) != nil)
        let parsed = Transaction.parse(jsonObject: obj)!
        #expect(parsed.comment == nil)
    }

    @Test func testParse_invalidJsonObject_returnsNil() {
        #expect(Transaction.parse(jsonObject: "not a dict") == nil)

        let badDict: [String: Any] = [
            "id": 1,
            "accountId": 2
        ]
        #expect(Transaction.parse(jsonObject: badDict) == nil)
    }
}
