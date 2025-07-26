//
//  BalanceHistoryChartView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 26.07.2025.
//

import SwiftUI
import Charts

struct BalanceHistoryChartView: View {
    enum StatisticPeriod: String, CaseIterable, Identifiable {
        case daily = "30 дней"
        case monthly = "24 месяца"

        var id: String { rawValue }
    }

    @Binding var transactions: [Transaction]
    @Binding var period: StatisticPeriod
    @Binding var isEditing: Bool

    @State private var selectedDate: Date? = nil
    @State private var showTooltip: Bool = false

    private var dataPoints: [DataPoint] {
        let calendar = Calendar.current
        let now = Date()

        switch period {
        case .daily:
            var points: [DataPoint] = []
            for offset in 0..<30 {
                guard let date = calendar.date(byAdding: .day, value: -offset, to: now) else { continue }
                let sum = transactions
                    .filter { calendar.isDate($0.transactionDate, inSameDayAs: date) }
                    .reduce(0.0) { acc, txn in
                        let signed = NSDecimalNumber(decimal: txn.amount).doubleValue * (txn.category.isIncome == .income ? 1 : -1)
                        return acc + signed
                    }
                points.append(DataPoint(date: date, amount: sum))
            }
            return Array(points.reversed())

        case .monthly:
            var points: [DataPoint] = []
            for offset in 0..<24 {
                guard let monthDate = calendar.date(byAdding: .month, value: -offset, to: now) else { continue }
                let month = calendar.component(.month, from: monthDate)
                let year = calendar.component(.year, from: monthDate)
                let sum = transactions
                    .filter {
                        let tMonth = calendar.component(.month, from: $0.transactionDate)
                        let tYear = calendar.component(.year, from: $0.transactionDate)
                        return tMonth == month && tYear == year
                    }
                    .reduce(0.0) { acc, txn in
                        let signed = NSDecimalNumber(decimal: txn.amount).doubleValue * (txn.category.isIncome == .income ? 1 : -1)
                        return acc + signed
                    }
                points.append(DataPoint(date: monthDate, amount: sum))
            }
            return Array(points.reversed())
        }
    }

    var body: some View {
        if !isEditing {
            VStack {
                Picker("", selection: $period) {
                    ForEach(StatisticPeriod.allCases) { p in
                        Text(p.rawValue).tag(p)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Chart(dataPoints) { point in
                    BarMark(
                        x: .value(
                            period == .daily ? "Дата" : "Месяц",
                            point.date,
                            unit: period == .daily ? .day : .month
                        ),
                        y: .value("Сумма", point.amount > 0 ? point.amount : -point.amount),
                        width: 8
                    )
                    .foregroundStyle(point.amount >= 0 ? .green : .red)
                    .opacity(selectedDate == point.date ? 0.7 : 1)
                }
                .chartOverlay { proxy in
                    GeometryReader { _ in
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        if let date: Date = proxy.value(atX: value.location.x) {
                                            if let nearest = dataPoints.min(by: {
                                                abs($0.date.timeIntervalSince1970 - date.timeIntervalSince1970) <
                                                    abs($1.date.timeIntervalSince1970 - date.timeIntervalSince1970)
                                            }) {
                                                selectedDate = nearest.date
                                                showTooltip = true
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        showTooltip = false
                                    }
                            )
                    }
                }
                .frame(height: 200)
                .chartYAxis(.hidden)
                .chartXAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisValueLabel(format: period == .daily
                            ? .dateTime.day()
                            : .dateTime.month(.abbreviated)
                        )
                    }
                }
                .animation(.easeInOut, value: period)

                if let date = selectedDate,
                   showTooltip,
                   let point = dataPoints.first(where: { $0.date.formatted(.dateTime.day().month().year()) == date.formatted(.dateTime.day().month().year()) }) {
                    Text(String(format: "%.0f", point.amount))
                        .font(.title)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct DataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}
