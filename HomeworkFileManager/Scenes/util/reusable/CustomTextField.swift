//
//  CustomTextField.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 29.08.2022.
//

import UIKit

final class CustomTextField: UITextField {
    let onValueChange: ((String) -> Void)?
    
    init(onValueChange: ((String) -> Void)? = nil) {
        self.onValueChange = onValueChange
        super.init(frame: .zero)
        configureTextField()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func configureTextField() {
        backgroundColor = .systemGray5
        borderStyle = .roundedRect
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftViewMode = .always
        addTarget(
            self,
            action: #selector(valueDidChange),
            for: .editingChanged)
    }
    
    @objc
    private func valueDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        onValueChange?(text)
    }
}
