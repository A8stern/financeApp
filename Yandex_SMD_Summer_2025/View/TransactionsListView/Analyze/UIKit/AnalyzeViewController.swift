//
//  AnalyzeViewController.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 11.07.2025.
//

import UIKit
import PieChart

class AnalyzeViewController: UIViewController {

    private let viewModel: AnalyzeViewModel

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Анализ"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let topTableVC: AnalyzeTopTableView
    private let pieChartView = PieChart()
    private let botTableVC: AnalyzeBotTableView
    
    var onTransactionSelect: ((Transaction) -> Void)?

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    

    init(direction: Direction, service: TransactionsService) {
        let viewModelInit = AnalyzeViewModel(direction: direction, service: service)
        self.viewModel = viewModelInit
        
        self.topTableVC = AnalyzeTopTableView(direction: direction, viewModel: viewModel)
        self.botTableVC = AnalyzeBotTableView(direction: direction, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.view = self
        botTableVC.onTransactionSelect = { [weak self] tx in
            self?.onTransactionSelect?(tx)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        Task {
            await viewModel.fetchTransactions()
        }
    }
    
    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
        
        stackView.addArrangedSubview(titleLabel)
        
        addChild(topTableVC)
        stackView.addArrangedSubview(topTableVC.view)
        topTableVC.didMove(toParent: self)
        
        stackView.addArrangedSubview(makeCenteredWrapper(for: pieChartView))
        
        addChild(botTableVC)
        stackView.addArrangedSubview(botTableVC.view)
        botTableVC.didMove(toParent: self)
    }
    
    private func makeCenteredWrapper(for view: UIView) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 150),
            view.heightAnchor.constraint(equalToConstant: 150),
            view.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }
    
    func reload() {
        topTableVC.tableView.reloadData()
        botTableVC.tableView.reloadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.topTableVC.tableView.layoutIfNeeded()
            self.botTableVC.tableView.layoutIfNeeded()

            let topHeight = self.topTableVC.tableView.contentSize.height
            let botHeight = self.botTableVC.tableView.contentSize.height

            self.topTableVC.view.heightAnchor.constraint(equalToConstant: topHeight).isActive = true
            self.botTableVC.view.heightAnchor.constraint(equalToConstant: botHeight).isActive = true
        }

        updatePieChart()
    }

    private func updatePieChart() {
        let grouped = Dictionary(grouping: viewModel.transactions, by: { $0.category.name })
        let pieData = grouped.map { (label, txs) in
            Entity(value: txs.reduce(0) { $0 + $1.amount }, label: label)
        }.sorted { $0.value > $1.value }
        
        pieChartView.entities = pieData
    }
}
