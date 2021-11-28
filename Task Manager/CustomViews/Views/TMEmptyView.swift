//
//  TMEmptyView.swift
//  Task Manager
//
//  Created by Duilan on 29/10/21.
//

import UIKit

class TMEmptyView: UIView {
    
    private let messageLabel = TMTitleLabel(fontSize: 20, textAlignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.textColor = ThemeColors.textDisabled
        NSLayoutConstraint.activate([
            messageLabel.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, constant: -40),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}

