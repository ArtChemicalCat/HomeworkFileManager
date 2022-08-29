//
//  UIAllertController+Extensions.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 29.08.2022.
//

import UIKit

extension UIAlertController {
    static func makeErrorAlert(with message: String) -> UIAlertController {
        UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert)
        .with {
            let action = UIAlertAction(
                title: "OK",
                style: .cancel)
            
            $0.addAction(action)
        }
    }
}
