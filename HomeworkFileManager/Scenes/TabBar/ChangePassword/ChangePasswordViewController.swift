//
//  ChangePasswordViewController.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 29.08.2022.
//

import UIKit
import SnapKit

final class ChangePasswordViewController: UIViewController {
    // MARK: - Views
    private lazy var passwordField = CustomTextField()
        .with { $0.isSecureTextEntry = true }
    private lazy var changePasswordButton = CustomButton(action: changePassword)
        .with { $0.setTitle("Изменить пароль", for: .normal) }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        view.backgroundColor = .systemBackground
    }
    
    // MARK: - Metods
    private func changePassword() {
        guard let password = passwordField.text,
              password.count > 3 else {
            let alert = UIAlertController.makeErrorAlert(with: "Пароль должен содержать не менее четырех символов")
            present(alert, animated: true)
            return
        }
        
        do {
            try KeychainPasswordItem(
                account: KeychainConstants.account,
                service: KeychainConstants.service).savePassword(password)
            self.dismiss(animated: true)
        }
        catch {
            let alert = UIAlertController.makeErrorAlert(with: error.localizedDescription)
            present(alert, animated: true)
        }
    }
    
    private func layout() {
        view.addSubviews(passwordField, changePasswordButton)
        
        changePasswordButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.centerY)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        passwordField.snp.makeConstraints {
            $0.leading.trailing.height.equalTo(changePasswordButton)
            $0.bottom.equalTo(changePasswordButton.snp.top).offset(-12)
        }
    }
}
