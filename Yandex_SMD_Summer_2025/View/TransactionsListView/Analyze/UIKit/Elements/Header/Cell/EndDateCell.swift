//
//  EndDateCell.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 11.07.2025.
//

import UIKit

class EndDateCell: UITableViewCell {
    
    private let label = UILabel()
    private let dateLabel = UILabel()
    private let background = UIView()
    private let datePicker = UIDatePicker()
    
    private var onDateChanged: ((Date) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(date: Date, onChange: @escaping (Date) -> Void) {
        datePicker.date = date
        dateLabel.text = Self.dateFormatter.string(from: date)
        self.onDateChanged = onChange
    }
    
    private func setupViews() {
        label.text = "Конец"
        label.font = .systemFont(ofSize: 17)
        
        dateLabel.font = .systemFont(ofSize: 17)
        dateLabel.textColor = .black
        dateLabel.textAlignment = .center

        background.layer.cornerRadius = 8
        background.backgroundColor = UIColor(named: "LightGreen") ?? UIColor.systemGreen.withAlphaComponent(0.3)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.tintColor = UIColor.accent
        datePicker.alpha = 0.02

        contentView.addSubview(label)
        contentView.addSubview(background)
        contentView.addSubview(datePicker)

        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            background.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            background.heightAnchor.constraint(equalToConstant: 32),
            background.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            dateLabel.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: background.centerYAnchor),

            datePicker.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: background.centerYAnchor)
        ])
    }

    @objc private func dateChanged() {
        let newDate = datePicker.date
        dateLabel.text = Self.dateFormatter.string(from: newDate)
        onDateChanged?(newDate)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("ddMMMyyyy")
        return formatter
    }()
}
