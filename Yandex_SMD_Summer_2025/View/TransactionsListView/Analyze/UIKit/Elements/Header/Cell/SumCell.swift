//
//  SumCell.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 11.07.2025.
//

import UIKit

class SumCell: UITableViewCell {
    
    private let label = UILabel()
    private let sumLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(sum: Decimal) {
        sumLabel.text = "\(sum) ₽"
    }

    private func setupViews() {
        label.text = "Сумма"
        label.font = .systemFont(ofSize: 17)
        
        sumLabel.font = .systemFont(ofSize: 17, weight: .medium)
        sumLabel.textColor = .label
        sumLabel.textAlignment = .right

        contentView.addSubview(label)
        contentView.addSubview(sumLabel)

        label.translatesAutoresizingMaskIntoConstraints = false
        sumLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            sumLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sumLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
