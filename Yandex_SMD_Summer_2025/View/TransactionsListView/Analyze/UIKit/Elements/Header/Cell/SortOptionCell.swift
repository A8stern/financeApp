//
//  SortOptionCell.swift
//  Yandex_SMD_Summer_2025
//
//  Created by Kovalev Gleb on 11.07.2025.
//

import UIKit

class SortOptionCell: UITableViewCell {
    
    private let label = UILabel()
    private let segmentedControl = UISegmentedControl(items: SortOption.allCases.map { $0.rawValue })

    private var onChange: ((SortOption) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(selected: SortOption, onChange: @escaping (SortOption) -> Void) {
        segmentedControl.selectedSegmentIndex = SortOption.allCases.firstIndex(of: selected) ?? 0
        self.onChange = onChange
    }

    private func setupViews() {
        label.text = "Отсортировано по"
        label.font = .systemFont(ofSize: 17)

        segmentedControl.addTarget(self, action: #selector(selectionChanged), for: .valueChanged)
        segmentedControl.selectedSegmentTintColor = UIColor(named: "LightGreen") ?? UIColor.systemGreen.withAlphaComponent(0.3)

        contentView.addSubview(label)
        contentView.addSubview(segmentedControl)

        label.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            segmentedControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            segmentedControl.widthAnchor.constraint(greaterThanOrEqualToConstant: 140)
        ])
    }

    @objc private func selectionChanged() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        guard selectedIndex >= 0 && selectedIndex < SortOption.allCases.count else { return }
        let selected = SortOption.allCases[selectedIndex]
        onChange?(selected)
    }
}
