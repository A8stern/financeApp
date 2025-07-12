//
//  EditSaveView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 12.07.2025.
//

import SwiftUI

struct EditCreateView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State
    var viewModel: EditCreateViewModel
    
    init(direction: Direction, mode: EditMode, transaction: Transaction?) {
        viewModel = EditCreateViewModel(direction: direction, editMode: mode, transaction: transaction)
    }
    
    var body: some View {
        NavigationStack {
            List {
                mainSection
                
                if viewModel.mode == .edit {
                    Section {
                        deleteButton
                            .foregroundStyle(.red)
                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
            .task {
                do {
                    try await viewModel.loadCategories()
                    try await viewModel.loadCategories()
                } catch {
                    print("Error: \(error)")
                }
            }
            .navigationTitle(viewModel.mode == .edit ? "Редактирование" : "Создание")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if viewModel.balanceText.isEmpty && viewModel.selectedCategory == nil {
                            viewModel.toggleAlert()
                        } else {
                            Task {
                                do {
                                    try await viewModel.saveOperation()
                                    dismiss()
                                } catch {
                                    print("Error: \(error)")
                                }
                            }
                        }
                    } label: {
                        Text(viewModel.mode == .create ? "Создать" : "Сохранить")
                    }
                }
            }
            .alert("Введите все поля", isPresented: $viewModel.showAlert, actions: {
                Button("Закрыть", role: .cancel, action: {viewModel.toggleAlert()})
            })
            .tint(Color("MyPurple"))
        }
    }
    
    var mainSection: some View {
        Section {
            categoryPicker
            
            sumPicker
            
            datePicker
            
            timePicker
            
            commentText
        }
    }
    
    var categoryPicker: some View {
        HStack {
            Text("Статья")
            
            Spacer()
            
            Picker("", selection: $viewModel.selectedCategory) {
                Text("Выберите статью")
                    .foregroundColor(.secondary)
                    .tag(Category?.none)
                
                ForEach(viewModel.allCategories, id: \.self) { category in
                    Text(category.name)
                        .tag(Optional(category))
                }
            }
            .pickerStyle(.menu)
            .tint(viewModel.selectedCategory == nil ? .secondary : .primary)
            
            Image(systemName: "chevron.right")
                .foregroundStyle(viewModel.selectedCategory == nil ? .secondary : .primary)
        }
    }
    
    var sumPicker: some View {
        HStack {
            Text("Сумма")
            
            Spacer()
            
            TextField(text: $viewModel.balanceText) {
                Text("0")
            }
            .foregroundStyle(viewModel.balanceText == "" ? .secondary : Color(.black))
            .multilineTextAlignment(.trailing)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            .onChange(of: viewModel.balanceText) {
                oldValue, newValue in
                
                let separator = Locale.current.decimalSeparator ?? "."
                var filtered = newValue.filter { char in
                    char.isNumber || String(char) == separator
                }
                let parts = filtered.split(separator: Character(separator), omittingEmptySubsequences: false)
                if parts.count > 2 {
                    filtered = parts[0] + separator + parts[1]
                }
                if filtered != newValue {
                    viewModel.balanceText = filtered
                }
            }
            
            Text(viewModel.currencyText)
                .foregroundStyle(viewModel.balanceText == "" ? .secondary : Color(.black))
            
            Image(systemName: "chevron.right")
                .foregroundStyle(viewModel.balanceText == "" ? .secondary : Color(.black))
        }
    }
    
    var datePicker: some View {
        HStack {
            Text("Дата")
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color("LightGreen"))
                
                Text(viewModel.chosenDate,
                     format: .dateTime.day().month().year())
                .foregroundColor(.primary)
                
                DatePicker(
                    "",
                    selection: $viewModel.chosenDate,
                    in: ...Date(),
                    displayedComponents: [.date]
                )
                .tint(Color.accent)
                .datePickerStyle(.compact)
                .labelsHidden()
                .opacity(0.1)
            }
            .fixedSize()
        }
    }
    
    var timePicker: some View {
        HStack {
            Text("Время")
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color("LightGreen"))
                
                Text(viewModel.chosenDate,
                     format: .dateTime.hour().minute())
                .foregroundColor(.primary)
                
                DatePicker(
                    "",
                    selection: $viewModel.chosenDate,
                    in: ...Date(),
                    displayedComponents: [.hourAndMinute]
                )
                .tint(Color.accent)
                .datePickerStyle(.compact)
                .labelsHidden()
                .opacity(0.1)
            }
            .fixedSize()
        }
    }
    
    var commentText: some View {
        TextField(text: $viewModel.comment) {
            Text("Комментарий")
        }
    }
    
    var deleteButton: some View {
        Button("Удалить расход") {
            Task {
                do {
                    try await viewModel.deleteOperation()
                    dismiss()
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
}

#Preview {
    EditCreateView(direction: .income, mode: .create, transaction: nil)
}
