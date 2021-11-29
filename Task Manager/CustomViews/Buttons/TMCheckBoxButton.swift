//
//  TMCheckBoxButton.swift
//  Task Manager
//
//  Created by Duilan on 28/11/21.
//

import UIKit

class TMCheckBoxButton: UIButton {
    
    private let iconConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
    
    private lazy var uncheckedIcon: UIImage? = {
        let i = UIImage(systemName: "circle.fill", withConfiguration: iconConfig)
        return i
    }()
    
    private lazy var checkedIcon: UIImage? = {
        let i = UIImage(systemName: "checkmark.circle.fill", withConfiguration: iconConfig)
        return i
    }()
    
    var isChecked: Bool = false  {
        didSet {
            updateIcon()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
        // estado por default unchecked
        isChecked = false
    }
    
    private func updateIcon() {
        if isChecked {
            self.setImage(checkedIcon, for: .normal)
            self.tintColor = ThemeColors.green
        } else {
            self.setImage(uncheckedIcon, for: .normal)
            self.tintColor = UIColor.lightGray.withAlphaComponent(0.2)
        }
    }
    
    @objc private func toggleCheck() {
        isChecked = !isChecked
    }
    
}
