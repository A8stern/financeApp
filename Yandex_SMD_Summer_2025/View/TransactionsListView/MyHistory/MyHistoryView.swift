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
    
    init(direction: Direction) {
        self.viewModel = MyHistoryViewModel(direction: direction)
    }
    
    var body: some View {
        List {
            headerSection
            
            transactionsList
        }
        .navigationTitle("Моя история")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "document")
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
    
    var sortOptions: some View {
        HStack {
            Text("Сумма")
            
            Spacer()
            
            Text("\(viewModel.sumOfTransactions) ₽")
        }
    }
    
    var sumForPeriod: some View {
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
                viewModel.sortTransactions()
            }
        }
    }
    
    var transactionsList: some View {
        Section("Операции") {
            ForEach(viewModel.transactions) { transaction in
                HStack {
                    ZStack {
                        Circle()
                            .frame(width: 22)
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
                .task {
                    
                }
            }
        }
    }
}



#Preview {
    MyHistoryView(direction: .income)
}
