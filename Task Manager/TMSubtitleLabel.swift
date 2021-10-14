//
//  TMSubtitleLabel.swift
//  Task Manager
//
//  Created by Duilan on 14/10/21.
//

import UIKit

final class TMSubtitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(fontSize: CGFloat = 16, weight: UIFont.Weight = .regular, textAlignment: NSTextAlignment = .left) {
        super.init(frame: .zero)
        setup()
        self.font = .systemFont(ofSize: fontSize, weight: weight)
        self.textAlignment = textAlignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        textColor = ThemeColors.subtitle
        numberOfLines = 1
        lineBreakMode = .byTruncatingTail
        font = .systemFont(ofSize: 16, weight: .regular)
        translatesAutoresizingMaskIntoConstraints = false        
    }
    
}
