//
//  PhotoTableViewCell.swift
//  HomeworkFileManager
//
//  Created by Николай Казанин on 28.08.2022.
//

import UIKit

final class PhotoTableViewCell: UITableViewCell {    
    private let photoView = UIImageView()
        .with {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    
    var image: UIImage? {
        didSet {
            photoView.image = image
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func layout() {
        addSubview(photoView)
        
        NSLayoutConstraint
            .activate([
                photoView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                photoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                photoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
                photoView.widthAnchor.constraint(equalToConstant: 100)
            ])
    }
}
