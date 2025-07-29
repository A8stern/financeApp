//
//  AnalyzeBotTableView.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 29.07.2025.
//

import UIKit

class AnalyzeBotTableView: UITableViewController {
    
    var viewModel: AnalyzeViewModel
    
    var onTransactionSelect: ((Transaction) -> Void)?
    
    init(direction: Direction, viewModel: AnalyzeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
//        self.viewModel.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(AnalyzeTransactionsCell.self, forCellReuseIdentifier: "TransactionsCell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactions.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsCell", for: indexPath) as! AnalyzeTransactionsCell
        let transaction = viewModel.transactions[indexPath.row]
        
        let amount = NSDecimalNumber(decimal: transaction.amount)
        let total = NSDecimalNumber(decimal: viewModel.sumOfTransactions)
        
        let rawPercent = amount.dividing(by: total).multiplying(by: 100)
        let percent = Int(rawPercent.doubleValue.rounded())
        
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ОПЕРАЦИИ"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tx = viewModel.transactions[indexPath.row]
        onTransactionSelect?(tx)
    }
}

