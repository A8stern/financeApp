//
//  AnalyzeViewController.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 11.07.2025.
//

import UIKit

class AnalyzeViewController: UIViewController {

    private let tableViewController: AnalyzeTableViewController
    
    var onTransactionSelect: ((Transaction) -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Анализ"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .label
        return label
    }()

    init(direction: Direction) {
        self.tableViewController = AnalyzeTableViewController(direction: direction)
        super.init(nibName: nil, bundle: nil)
        tableViewController.onTransactionSelect = { [weak self] tx in
            self?.onTransactionSelect?(tx)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground

        view.addSubview(titleLabel)

        addChild(tableViewController)
        view.addSubview(tableViewController.view)
        tableViewController.didMove(toParent: self)

        tableViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            tableViewController.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
