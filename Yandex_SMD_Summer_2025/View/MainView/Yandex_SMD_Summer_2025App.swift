//
//  Yandex_SMD_Summer_2025App.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 14.06.2025.
//

import SwiftUI
import SwiftData

@main
struct Yandex_SMD_Summer_2025App: App {
    static let schema = Schema([
        CategoryEntity.self,
        BankAccountEntity.self,
        TransactionEntity.self,
        BackupOperation.self,
        BackupAccount.self
    ])
    
    static let container: ModelContainer = {
        let config = ModelConfiguration("GlobalStore", schema: schema)
        return try! ModelContainer(for: schema, configurations: config)
    }()
    
    @StateObject private var categoryService: CategoriesService
    @StateObject private var bankAccountService: BankAccountsService
    @StateObject private var transactionService: TransactionsService
    
    init() {
        let ctx = Self.container.mainContext
        
        let cs = CategoriesService(context: ctx)
        
        let bs = BankAccountsService(context: ctx)
        
        let ts = TransactionsService(
            context: ctx,
            categoryService: cs,
            bankAccountService: bs
        )
        
        bs.transactionsService = ts
        
        _categoryService = StateObject(wrappedValue: cs)
        _bankAccountService = StateObject(wrappedValue: bs)
        _transactionService = StateObject(wrappedValue: ts)
    }
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(categoryService)
                .environmentObject(bankAccountService)
                .environmentObject(transactionService)
                .environment(\.colorScheme, .light)
        }
    }
}
