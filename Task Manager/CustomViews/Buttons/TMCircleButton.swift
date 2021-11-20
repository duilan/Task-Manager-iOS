//
//  TMCircleButton.swift
//  Task Manager
//
//  Created by Duilan on 18/11/21.
//

import UIKit

class TMCircleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSystemIcon(name: String, pointSize: CGFloat ) {
        setImage(UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: pointSize, weight: .bold)), for: .normal)
    }
    
    private func setup() {
        clipsToBounds = true
        tintColor = .white
        backgroundColor = ThemeColors.accentColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.height / 2
    }
    
}
