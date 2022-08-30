//
//  SortingTableViewCell.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 29.08.2022.
//

import UIKit
import SnapKit

final class SortingTableViewCell: UITableViewCell {
    // MARK: - Views
    let titleLabel = UILabel()
        .with {
            $0.text = "Сортировать в алфавитном порядке"
        }
    
    private lazy var toggleSort = UISwitch()
        .with {
            $0.addTarget(self, action: #selector(toggleSorting), for: .valueChanged)
            $0.preferredStyle = .sliding
            $0.setOn(true, animated: true)
        }
    // MARK: - Properties
    var toggleSortingOn: ((_ isOn: Bool) -> Void)?
    
    // MARK: - Initialisation
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Actions
    @objc
    private func toggleSorting(_ switch: UISwitch) {
        toggleSortingOn?(`switch`.isOn)
    }
    
    // MARK: - Metods
    private func configureCell() {
        contentView.addSubviews(titleLabel, toggleSort)
        selectionStyle = .none
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
        
        toggleSort.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.centerY.equalTo(titleLabel)
        }
    }
}
