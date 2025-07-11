//
//  AnalyzeTransactionsCell.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 11.07.2025.
//

import UIKit

class AnalyzeTransactionsCell: UITableViewCell {
    
    private let emojiBackground = UIView()
    private let emojiLabel = UILabel()
    
    private let nameLabel = UILabel()
    private let commentLabel = UILabel()
    
    private let percentageLabel = UILabel()
    private let amountLabel = UILabel()
    
    private let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        // Emoji background
        emojiBackground.backgroundColor = UIColor(named: "LightGreen") ?? UIColor.systemGreen.withAlphaComponent(0.2)
        emojiBackground.layer.cornerRadius = 14
        emojiBackground.translatesAutoresizingMaskIntoConstraints = false

        emojiLabel.font = .systemFont(ofSize: 17)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false

        emojiBackground.addSubview(emojiLabel)
        contentView.addSubview(emojiBackground)

        // Text labels
        nameLabel.font = .systemFont(ofSize: 17, weight: .regular)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        commentLabel.font = .systemFont(ofSize: 17)
        commentLabel.textColor = .secondaryLabel
        commentLabel.lineBreakMode = .byTruncatingTail
        commentLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(nameLabel)
        contentView.addSubview(commentLabel)

        // Percentage + amount
        percentageLabel.font = .systemFont(ofSize: 17)
        percentageLabel.textAlignment = .right
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false

        amountLabel.font = .systemFont(ofSize: 17)
        amountLabel.textAlignment = .right
        amountLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(percentageLabel)
        contentView.addSubview(amountLabel)

        // Chevron
        chevronImageView.tintColor = .tertiaryLabel
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chevronImageView)

        // Constraints
        if commentLabel.text != "" {
            NSLayoutConstraint.activate([
                // Emoji background
                emojiBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                emojiBackground.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                emojiBackground.widthAnchor.constraint(equalToConstant: 28),
                emojiBackground.heightAnchor.constraint(equalToConstant: 28),
                
                emojiLabel.centerXAnchor.constraint(equalTo: emojiBackground.centerXAnchor),
                emojiLabel.centerYAnchor.constraint(equalTo: emojiBackground.centerYAnchor),
                
                nameLabel.leadingAnchor.constraint(equalTo: emojiBackground.trailingAnchor, constant: 12),
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: percentageLabel.leadingAnchor, constant: -8),
                
                // Comment label
                commentLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                commentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
                commentLabel.trailingAnchor.constraint(lessThanOrEqualTo: amountLabel.leadingAnchor, constant: -8),
                commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                
                // Percentage label
                percentageLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
                percentageLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -4),
                
                // Amount label
                amountLabel.topAnchor.constraint(equalTo: percentageLabel.bottomAnchor, constant: 2),
                amountLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -4),
                amountLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
                
                // Chevron
                chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                chevronImageView.widthAnchor.constraint(equalToConstant: 12)
            ])
        } else {
            NSLayoutConstraint.activate([
                // Emoji background
                emojiBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                emojiBackground.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                emojiBackground.widthAnchor.constraint(equalToConstant: 28),
                emojiBackground.heightAnchor.constraint(equalToConstant: 28),
                
                emojiLabel.centerXAnchor.constraint(equalTo: emojiBackground.centerXAnchor),
                emojiLabel.centerYAnchor.constraint(equalTo: emojiBackground.centerYAnchor),
                
                nameLabel.leadingAnchor.constraint(equalTo: emojiBackground.trailingAnchor, constant: 12),
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
                nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: percentageLabel.leadingAnchor, constant: -8),
                
                // Percentage label
                percentageLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
                percentageLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -4),
                
                // Amount label
                amountLabel.topAnchor.constraint(equalTo: percentageLabel.bottomAnchor, constant: 2),
                amountLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -4),
                amountLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
                
                // Chevron
                chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                chevronImageView.widthAnchor.constraint(equalToConstant: 12)
            ])
        }
    }

    func configure(categoryEmoji: Character, categoryName: String, comment: String?, amount: Decimal, percentage: Int) {
        emojiLabel.text = String(categoryEmoji)
        nameLabel.text = categoryName
        commentLabel.text = comment
        commentLabel.isHidden = (comment == nil)
        amountLabel.text = "\(amount) ₽"
        percentageLabel.text = "\(percentage)%"
    }
}
