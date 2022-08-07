//
//  TMTextField.swift
//  Task Manager
//
//  Created by Duilan on 31/10/21.
//

import UIKit

class TMTextField: UITextField {
    
    private let titleLabel = UILabel()
    private let paddingInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 8, bottom: 0, right: 8)
    private let borderView = UIView()
    
    var title: String? {
        didSet {
            titleLabel.text = title?.uppercased()
        }
    }
    
    private var isEmpty: Bool {
        text?.isEmpty ?? true
    }
    
    override var tintColor: UIColor! {
        didSet {
            borderView.backgroundColor = tintColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupTitleLabel()
        setupBorderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func editEvent() {
        if isFirstResponder {
            UIView.animate(withDuration: 0.25) {
                self.titleLabel.textColor = self.tintColor
                self.borderView.alpha = 1
                self.borderView.transform = .identity
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.titleLabel.textColor = self.textColor?.withAlphaComponent(0.6)
                self.borderView.transform = CGAffineTransform(scaleX: 0, y: 0)
            }
        }
    }
    
    private func setup() {
        self.textColor = ThemeColors.title
        self.tintColor = ThemeColors.accentColor
        self.clipsToBounds = true
        self.backgroundColor = .white        
        self.addTarget(self, action: #selector(editEvent), for: .allEditingEvents)
    }
    
    private func setupBorderView() {
        addSubview(borderView)
        borderView.alpha = 0
        borderView.backgroundColor = self.tintColor
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textColor = textColor?.withAlphaComponent(0.6)
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: paddingInset))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds.inset(by: paddingInset))
    }
    
}
