//
//  TMSquareIconView.swift
//  Task Manager
//
//  Created by Duilan on 19/10/21.
//

import UIKit

final class TMSquareIconView: UIView {
    private let imageView = UIImageView()
    public var systemNameIcon: String = "questionmark.square" {
        didSet {
            DispatchQueue.main.async { self.setIcon() }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setIcon()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setIcon() {
        self.imageView.image = UIImage(systemName: self.systemNameIcon) ?? UIImage(systemName: "questionmark.square")
    }
    
    private func setup() {
        addSubview(imageView)
        self.clipsToBounds = false
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 10
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalTo: widthAnchor, constant: -padding),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
