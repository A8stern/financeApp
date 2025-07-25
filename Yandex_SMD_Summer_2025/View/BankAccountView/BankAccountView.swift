//
//  BankAccountView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

struct BankAccountView: View {
    @StateObject private var viewModel: BankAccountViewModel
    
    init(service: BankAccountsService) {
        _viewModel = StateObject(
            wrappedValue: BankAccountViewModel(service: service)
        )
    }
    
    var body: some View {
        NavigationStack {
            
            List {
                if viewModel.isLoaded {
                    balanceView
                    
                    currencyView
                } else {
                    ProgressView()
                }
            }
            
            .alert(viewModel.localizedError, isPresented: $viewModel.showAlert, actions: {
                Button("Закрыть") {
                    viewModel.showAlert = false
                }
            })
            .refreshable {
                viewModel.refreshValues()
            }
            .onShake {
                viewModel.deviceShaken()
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
        .task {
            await viewModel.getAccount()
        }
        .tint(Color("MyPurple"))
    }
    
    
    
    var balanceView: some View {
        Section {
            HStack {
                Text("💰 Баланс:")
                
                Spacer()
                
                if viewModel.balanceText != "000" {
                    ZStack {
                        if !viewModel.isBalanceHidden {
                            TextField(text: $viewModel.balanceText) {
                                Text(viewModel.balanceText)
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
                        }
                        
                        if viewModel.isBalanceHidden {
                            SpoilerView(isOn: viewModel.isBalanceHidden)
                                .padding(.vertical, 11)
                                .opacity(viewModel.isBalanceHidden ? 1 : 0)
                                .animation(.default, value: viewModel.isBalanceHidden)
                        }
                    }
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

//#Preview {
//    BankAccountView()
//}
