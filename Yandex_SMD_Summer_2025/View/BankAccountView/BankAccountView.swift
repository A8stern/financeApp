//
//  BankAccountView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

struct BankAccountView: View {
    
    @State
    var viewModel = BankAccountViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                balanceView
                
                currencyView
            }
            .refreshable {
                viewModel.refreshValues()
            }
            .scrollDismissesKeyboard(.immediately)
            .confirmationDialog("Валюта", isPresented: $viewModel.showCurrencyPicker, titleVisibility: .visible) {
                ForEach(CurrencyInApp.allCases) { currency in
                    if currency != .didNotLoad {
                        Button(currency.rawValue) {
                            viewModel.selectedCurrency = currency
                        }
                    }
                }
            }
            .navigationTitle("Мой счет")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.toolBarButtonTapped()
                    } label: {
                        Text(viewModel.isEditing ? "Сохранить" : "Редактировать")
                    }

                }
            }
        }
        .tint(Color("MyPurple"))
    }
    
    
    
    var balanceView: some View {
        Section {
            HStack {
                Text("💰 Баланс:")
                
                Spacer()
                
                if viewModel.balanceText != "000" {
                    TextField(text: $viewModel.balanceText) {
                        Text(viewModel.balanceText)
                    }
                    .spoiler(isOn: $viewModel.isBalanceHidden)
                    .onShake {
                        viewModel.deviceShaken()
                    }
                    .contextMenu {
                        if viewModel.isEditing {
                            Button("Вставить из буфера") {
                                viewModel.pasteTextFromClipboard()
                            }
                        }
                    }
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .disabled(!viewModel.isEditing || viewModel.isBalanceHidden)
                } else {
                    ProgressView()
                }
            }
            .listRowBackground(viewModel.isEditing ? .white : Color.accent)
        }
    }
    
    var currencyView: some View {
        Section {
            HStack {
                Text("Валюта:")
                
                Spacer()
                
                if viewModel.currencyText != "" {
                    Text(viewModel.currencyText)
                    
                    if viewModel.isEditing {
                        Image(systemName: "chevron.right")
                    }
                } else {
                    ProgressView()
                }
            }
            .onTapGesture {
                viewModel.currencySectionTapped()
            }
            .listRowBackground(viewModel.isEditing ? .white : Color("LightGreen"))
        }
    }
}

#Preview {
    BankAccountView()
}
