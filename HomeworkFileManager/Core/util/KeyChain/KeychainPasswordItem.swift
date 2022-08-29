//
//  KeyChainPasswordItem.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 29.08.2022.
//

import Foundation

enum KeychainConstants {
    static var service: String { "password" }
    static var account: String { "Artchemist@yandex.ru" }
}

struct KeychainPasswordItem {
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }
    
    // MARK: - Properties
    private(set) var account: String
    let service: String
    let accessGroup: String?
    
    init(account: String, service: String, accessGroup: String? = nil) {
        self.account = account
        self.service = service
        self.accessGroup = accessGroup
    }
    
    // MARK: - Keychain access
    func readPassword() throws -> String {
        var query = KeychainPasswordItem.keychainQuery(
            withService: service,
            account: account,
            accessGroup: accessGroup)
        
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = queryResult as? [String: AnyObject],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: .utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    func savePassword(_ password: String) throws {
        let encodedPassword = password.data(using: .utf8)
        
        do {
            try _ = readPassword()
            
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = KeychainPasswordItem
                .keychainQuery(
                    withService: service,
                    account: account,
                    accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        } catch KeychainError.noPassword {
            var newItem = KeychainPasswordItem.keychainQuery(
                withService: service,
                account: account,
                accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }
    
    func deleteItem() throws {
        let query = KeychainPasswordItem
            .keychainQuery(
                withService: service,
                account: account,
                accessGroup: accessGroup)
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
}
