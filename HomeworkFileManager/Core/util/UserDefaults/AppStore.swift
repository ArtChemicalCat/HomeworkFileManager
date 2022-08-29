//
//  AppStore.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 29.08.2022.
//

import Foundation

protocol PropertyListValue {}

extension Data: PropertyListValue {}
extension String: PropertyListValue {}
extension Date: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}

@propertyWrapper
struct AppStorage<T: PropertyListValue> {
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? value }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
    var projectedValue: AppStorage<T> { self }
    
    private var value: T
    private let key: String
    
    init(wrappedValue: T, key: String) {
        self.key = key
        self.value = wrappedValue
        guard UserDefaults.standard.object(forKey: key) == nil else { return }
        
        UserDefaults.standard.set(wrappedValue, forKey: key)
    }
    
    func observe(change: @escaping (T?) -> Void ) -> NSObject {
        return DefaultsObservation(key: key) {
            change($0 as? T)
        }
    }
}


class DefaultsObservation: NSObject {
    let key: String
    private var onChange: (Any) -> Void

    init(key: String, onChange: @escaping (Any) -> Void) {
        self.onChange = onChange
        self.key = key
        super.init()
        UserDefaults.standard.addObserver(self, forKeyPath: key, options: [.old, .new], context: nil)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard let change = change, object != nil, keyPath == key else { return }
        onChange(change[.newKey] as Any)
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: key, context: nil)
    }
}
