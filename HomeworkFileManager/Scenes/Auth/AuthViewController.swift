//
//  AuthViewController.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 29.08.2022.
//

import UIKit
import SnapKit
import Combine

final class AuthViewController: UIViewController {
    // MARK: - Views
    private lazy var passwordField = CustomTextField(onValueChange: passwordDidChange)
        .with { $0.isSecureTextEntry = true }
    
    private lazy var passwordButton = CustomButton(action: passwordButtonDidTapped)
    
    // MARK: - Properties
    private let viewModel: AuthViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initialisation
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setBackground()
        bind(to: viewModel)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        constructHierarchy()
        makeConstraints()
        addDismissKeyboardGesture()
    }
    
    // MARK: - Metods
    private func bind(to viewModel: AuthViewModel) {
        // auth state
        viewModel
            .$authViewState
            .removeDuplicates()
            .sink { [weak self] state in
                switch state {
                case .notRegistered:
                    self?.passwordButton.setTitle("Создать пароль", for: .normal)
                case .registered(let registeredState):
                    switch registeredState {
                    case .loggedOut:
                        self?.passwordButton.setTitle("Введите пароль", for: .normal)
                    case .loggedIn:
                        self?.showDocumentsScreen()
                    }
                    
                case .confirmPassword:
                    self?.passwordField.text = ""
                    self?.passwordButton.setTitle("Повторите пароль", for: .normal)
                }
            }
            .store(in: &subscriptions)
        
        // errors
        viewModel
            .$errorMessage
            .dropFirst()
            .sink { [weak self] message in
                self?.present(
                    UIAlertController.makeErrorAlert(with: message),
                    animated: true)
            }
            .store(in: &subscriptions)

    }
    
    private func showDocumentsScreen() {
        let tabBar = UITabBarController()
            .with {
                $0.setViewControllers(
                    [
                        UINavigationController(rootViewController: DocumentsViewController())
                            .with {
                                $0.tabBarItem.image = UIImage(systemName: "list.bullet")
                                $0.tabBarItem.title = "Фото"
                            },
                        UINavigationController(rootViewController: SettingsViewController(viewModel: SettingsViewModel()))
                            .with {
                                $0.tabBarItem.image = UIImage(systemName: "gear")
                                $0.tabBarItem.title = "Настройки"
                            }
                    ],
                    animated: true)
            }
        
        view.window?.rootViewController = tabBar
    }
    
    private func addDismissKeyboardGesture() {
        let dismissKeyboardOnTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyboardOnTap)
    }
    
    // MARK: - Actions
    func passwordButtonDidTapped() {
        dismissKeyboard()
        viewModel.passwordButtonDidTapped()
    }
    
    func passwordDidChange(_ text: String) {
        viewModel.passwordDidChange(password: text)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Layout
    private func setBackground() {
        view.backgroundColor = .systemBackground
    }
    
    private func constructHierarchy() {
        view.addSubviews(passwordField, passwordButton)
    }
    
    private func makeConstraints() {
        passwordButton.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.centerY)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        passwordField.snp.makeConstraints {
            $0.leading.trailing.height.equalTo(passwordButton)
            $0.bottom.equalTo(passwordButton.snp.top).offset(-12)
        }
    }
}
