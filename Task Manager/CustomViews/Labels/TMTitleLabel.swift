//
//  TMTitleLabel.swift
//  Task Manager
//
//  Created by Duilan on 14/10/21.
//

import UIKit

final class TMTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(fontSize: CGFloat, weight: UIFont.Weight = .bold, textAlignment: NSTextAlignment = .left, colorInverted: Bool = false) {
        super.init(frame: .zero)
        setup()
        self.font = .systemFont(ofSize: fontSize, weight: weight)
        self.textAlignment = textAlignment
        self.textColor = colorInverted ? ThemeColors.titleInverted : ThemeColors.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        textColor = ThemeColors.title
        numberOfLines = 1
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
