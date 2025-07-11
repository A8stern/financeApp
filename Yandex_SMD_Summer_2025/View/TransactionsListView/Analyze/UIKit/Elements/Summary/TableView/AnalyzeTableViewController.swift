//
//  AnalyzeTableViewController.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 11.07.2025.
//

import UIKit

class AnalyzeTableViewController: UITableViewController {
    
    var viewModel: AnalyzeViewModel
    
    init(direction: Direction) {
        self.viewModel = AnalyzeViewModel(direction: direction)
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(StartDateCell.self, forCellReuseIdentifier: "StartDateCell")
        tableView.register(EndDateCell.self, forCellReuseIdentifier: "EndDateCell")
        tableView.register(SortOptionCell.self, forCellReuseIdentifier: "SortOptionCell")
        tableView.register(SumCell.self, forCellReuseIdentifier: "SumCell")
        tableView.register(AnalyzeTransactionsCell.self, forCellReuseIdentifier: "TransactionsCell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 4
        case 1: return viewModel.transactions.count
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "StartDateCell", for: indexPath) as! StartDateCell
                cell.configure(date: viewModel.startOfPeriod) { [weak self] newDate in
                    if newDate > self?.viewModel.endOfPeriod ?? Date() {
                        let newEnd = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: Calendar.current.startOfDay(for: newDate))!
                        self?.viewModel.endOfPeriod = newEnd
                    }
                    let newStart = Calendar.current.startOfDay(for: newDate)
                    self?.viewModel.startOfPeriod = newStart
                    Task { await self?.viewModel.fetchTransactions() }
                }
                
                cell.selectionStyle = .none
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "EndDateCell", for: indexPath) as! EndDateCell
                cell.configure(date: viewModel.endOfPeriod) { [weak self] newDate in
                    if newDate < self?.viewModel.startOfPeriod ?? Date() {
                        let newStart = Calendar.current.startOfDay(for: newDate)
                        self?.viewModel.startOfPeriod = newStart
                    }
                    let newEnd = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: Calendar.current.startOfDay(for: newDate))!
                    self?.viewModel.endOfPeriod = newEnd
                    Task { await self?.viewModel.fetchTransactions() }
                }
                cell.selectionStyle = .none
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SortOptionCell", for: indexPath) as! SortOptionCell
                cell.configure(selected: viewModel.sortOption) { [weak self] newOption in
                    Task {
                        self?.viewModel.sortOption = newOption
                        await self?.viewModel.sortTransactions(
                            self?.viewModel.transactions ?? []
                        )
                    }
                }
                cell.selectionStyle = .none
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SumCell", for: indexPath) as! SumCell
                cell.configure(sum: viewModel.sumOfTransactions)
                cell.selectionStyle = .none
                return cell
            default:
                fatalError("Unhandled row") // прокидываем fatal error для откладки
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsCell", for: indexPath) as! AnalyzeTransactionsCell
            let transaction = viewModel.transactions[indexPath.row]

            let amount = NSDecimalNumber(decimal: transaction.amount)
            let total = NSDecimalNumber(decimal: viewModel.sumOfTransactions)

            let rawPercent = amount.dividing(by: total).multiplying(by: 100)
            let percent = Int(rawPercent.doubleValue.rounded())
            
            print(total)

            cell.configure(
                categoryEmoji: transaction.category.emoji,
                categoryName: transaction.category.name,
                comment: transaction.comment,
                amount: transaction.amount,
                percentage: percent
            )
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return nil
        case 1: return "ОПЕРАЦИИ"
        default: return nil
        }
    }
}
