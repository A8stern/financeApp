//
//  extension Transaction + parse(jsonObject).swift
//  Yandex_SMD_2025
//
//  Created by Kovalev Gleb on 13.06.2025.
//

import Foundation

extension Transaction {
    static func parse(jsonObject: Any) -> Transaction? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject)
            
            let transaction = try JSONDecoder().decode(Transaction.self, from: jsonData)
            return transaction
        }
        catch {
            print(error)
            return nil
        }
    }
}
