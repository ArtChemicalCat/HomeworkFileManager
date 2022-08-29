//
//  SettingsViewController.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 29.08.2022.
//

import UIKit
import SnapKit

final class SettingsViewController: UIViewController {
    private lazy var list = UITableView()
        .with {
            $0.rowHeight = 60
            $0.register(SortingTableViewCell.self, forCellReuseIdentifier: SortingTableViewCell.id)
            $0.dataSource = self
            $0.delegate = self
        }
    
    private let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        view.backgroundColor = .systemBackground
    }
    
    private func layout() {
        view.addSubview(list)
        
        list.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let VC = ChangePasswordViewController()
            present(VC, animated: true)
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 2 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SortingTableViewCell.id,
                for: indexPath) as! SortingTableViewCell
            
            cell.toggleSortingOn = viewModel.toggleSortingOn(_:)
            return cell

        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                .with { $0.selectionStyle = .none }
            cell.textLabel?.text = "Сменить пароль"
            return cell
        }
    }
    
    
}
