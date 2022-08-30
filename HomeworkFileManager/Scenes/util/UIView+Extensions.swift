//
//  UIView.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 29.08.2022.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

extension UIView {
    static var id: String {
        String(describing: self)
    }
}
