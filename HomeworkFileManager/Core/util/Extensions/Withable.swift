//
//  Withable.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 28.08.2022.
//

import Foundation

protocol Withable {
    associatedtype T
    
    @discardableResult
    func with(_ closure: (_ instance: T) -> Void) -> T
}

extension Withable {
    func with(_ closure: (_ instance: Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: Withable {}
