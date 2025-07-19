//
//  MyHistoryView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 20.06.2025.
//

import SwiftUI

struct MyHistoryView: View {
    
    @State
    var viewModel: MyHistoryViewModel
    
    @EnvironmentObject var router: TransactionListRouter
    
    private enum MyHistoryMetrics {
        static let circleForIconRadius: CGFloat = 22
    }
    
    init(direction: Direction) {
        self.viewModel = MyHistoryViewModel(direction: direction)
    }
    
    var body: some View {
        List {
            headerSection
            
            if viewModel.gotTransactions {
                transactionsList
            } else {
                ProgressView()
            }
        }
        .alert(viewModel.localizedError, isPresented: $viewModel.showAlert, actions: {
            Button("Закрыть") {
                viewModel.showAlert = false
            }
        })
        .fullScreenCover(
            isPresented: $viewModel.showEditScreen,
            onDismiss: {
                Task {
                    await viewModel.fetchTransactions()
                }
            },
            content: {
                EditCreateView(
                    direction: viewModel.direction,
                    mode: .edit,
                    transaction: viewModel.chosenTransaction
                )
            }
        )
        .navigationTitle("Моя история")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.navigateTo(.analyze(viewModel.direction))
                } label: {
                    Image(systemName: "document")
                }
            }
        }
    }
    
    var headerSection: some View {
        Section {
            dateRow(label: "Начало", date: $viewModel.startOfPeriod) { newValue in
                if newValue > viewModel.endOfPeriod {
                    let newEnd = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: Calendar.current.startOfDay(for: newValue))!
                    viewModel.endOfPeriod = newEnd
                }
                let newStart = Calendar.current.startOfDay(for: newValue)
                viewModel.startOfPeriod = newStart
                Task { await viewModel.fetchTransactions() }
            }
            
            dateRow(label: "Конец", date: $viewModel.endOfPeriod) { newValue in
                if newValue < viewModel.startOfPeriod {
                    let newStart = Calendar.current.startOfDay(for: newValue)
                    viewModel.startOfPeriod = newStart
                }
                let newEnd = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: Calendar.current.startOfDay(for: newValue))!
                viewModel.endOfPeriod = newEnd
                Task { await viewModel.fetchTransactions() }
            }
            
            sortOptions
            
            sumForPeriod
        }
    }
    
    @ViewBuilder
    private func dateRow(
            label: String,
            date: Binding<Date>,
            onDateChange: @escaping (Date) -> Void
    ) -> some View {
        HStack {
            Text(label)
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color("LightGreen"))
                Text(date.wrappedValue,
                     format: .dateTime.day().month().year())
                .foregroundColor(.primary)
                DatePicker("", selection: date, displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .opacity(0.1)
                    .onChange(of: date.wrappedValue) { oldValue, newValue in
                        onDateChange(newValue)
                    }
            }
            .fixedSize()
        }
    }
    
    var sumForPeriod: some View {
        HStack {
            Text("Сумма")
            
            Spacer()
            
            Text("\(viewModel.sumOfTransactions) ₽")
        }
    }
    
    var sortOptions: some View {
        HStack {
            Text("Отсортировано по")
            
            Spacer()
            
            Picker("", selection: $viewModel.sortOption) {
                ForEach(SortOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .colorMultiply(Color("LightGreen"))
            .fixedSize()
            .onChange(of: viewModel.sortOption) { oldValue, newValue in
                viewModel.sortTransactions(viewModel.transactions)
            }
        }
    }
    
    var transactionsList: some View {
        Section("Операции") {
            ForEach(viewModel.transactions) { transaction in
                Button {
                    viewModel.chosenTransaction = transaction
                    viewModel.showEditScreen.toggle()
                } label: {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: MyHistoryMetrics.circleForIconRadius)
                                .foregroundStyle(Color("LightGreen"))
                            
                            Text("\(transaction.category.emoji)")
                                .font(.system(size: 12))
                        }
                        VStack(alignment: .leading) {
                            Text(transaction.category.name)
                                .font(.system(size: 17))
                            if let secondText = transaction.comment {
                                Text(secondText)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Text("\(transaction.amount) ₽")
                            .font(.system(size: 17))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13))
                            .foregroundStyle(.tertiary)
                    }
                    .tint(.black)
                }
            }
        }
    }
}



#Preview {
    MyHistoryView(direction: .income)
}
