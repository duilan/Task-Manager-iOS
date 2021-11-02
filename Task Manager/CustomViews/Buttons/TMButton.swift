//
//  TMButton.swift
//  Task Manager
//
//  Created by Duilan on 31/10/21.
//

import UIKit

class TMButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ title: String, color: UIColor = ThemeColors.accentColor) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        backgroundColor = color
        setup()
    }
    
    private func setup() {
        tintColor = .white
        setTitleColor(.white, for: .normal)
        clipsToBounds = true
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        layer.cornerRadius = (self.bounds.height * 0.8) / 2
        layer.cornerCurve = .continuous
    }
    
}
