//
//  AuthViewModel.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 29.08.2022.
//

import Foundation

final class AuthViewModel {
    // MARK: - Types
    enum RegisteredState: Comparable {
        case loggedIn
        case loggedOut
    }
    
    enum AuthViewState: Comparable {
        case registered(RegisteredState)
        case notRegistered
        case confirmPassword
    }
    
    // MARK: - Published
    @Published private(set) var authViewState: AuthViewState
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var isFirstPassword = true
    
    // MARK: - Properties
    private(set) var password: String = ""
    private(set) var confirmPassword: String = ""
    
    // MARK: - Initialisation
    init() {
        if let _ = try? KeychainPasswordItem(
            account: KeychainConstants.account,
            service: KeychainConstants.service).readPassword() {
            authViewState = .registered(.loggedOut)
        } else {
            authViewState = .notRegistered
        }
    }
    
    // MARK: - View Actions
    func passwordDidChange(password: String) {
        if isFirstPassword {
            self.password = password
        } else {
            self.confirmPassword = password
        }
    }
    
    func passwordButtonDidTapped() {
        guard password.count > 3 else {
            errorMessage = "Пароль должен состоять не менее чем из четырех символов"
            return
        }
        
        switch authViewState {
        case .registered:
            enter(with: password)
            
        case .notRegistered:
            isFirstPassword = false
            authViewState = .confirmPassword
            
        case .confirmPassword:
            registerPassword()
        }
    }
    
    private func enter(with password: String) {
        do {
            let savedPassword = try KeychainPasswordItem(
                account: KeychainConstants.account,
                service: KeychainConstants.service).readPassword()
            
            if savedPassword == password {
                authViewState = .registered(.loggedIn)
            } else {
                errorMessage = "Неверный пароль"
            }
        }
        catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func registerPassword() {
        guard password == confirmPassword else {
            errorMessage = "Пароли не совпадают"
            authViewState = .notRegistered
            return
        }
        
        do {
            try KeychainPasswordItem(
                account: KeychainConstants.account,
                service: KeychainConstants.service).savePassword(password)
            
            authViewState = .registered(.loggedIn)
        }
        catch {
            errorMessage = error.localizedDescription
        }

    }
}
