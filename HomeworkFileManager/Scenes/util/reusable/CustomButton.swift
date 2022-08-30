//
//  Button.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 29.08.2022.
//

import UIKit
import Combine

final class CustomButton: UIButton {
    private var subscriptions = Set<AnyCancellable>()
    
    var action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
        super.init(frame: .zero)
        configureButton()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func configureButton() {
        let config = UIButton.Configuration.plain()
        
        configuration = config
        tintColor = .white
        layer.cornerRadius = 6
        backgroundColor = .systemPink
        addTarget(
            self,
            action: #selector(buttonDidTapped),
            for: .touchUpInside)
        
        publisher(for: \.isHighlighted)
            .sink { isSelected in
                UIView.animate(withDuration: 0.3) {
                    self.alpha = isSelected ? 0.6 : 1
                }
            }
            .store(in: &subscriptions)
    }
    
    @objc
    private func buttonDidTapped() {
        action()
    }
}
