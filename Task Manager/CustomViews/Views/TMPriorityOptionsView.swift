//
//  TMPriorityOptionsView.swift
//  Task Manager
//
//  Created by Duilan on 11/12/21.
//

import UIKit


class TMPriorityOptionsView: UIView {
    
    private let titleLabel = UILabel()
    private let stackH = UIStackView()
    
    var currentPriority: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupTitle()
        setupOptions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.cornerCurve = .continuous
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTitle() {
        addSubview(titleLabel)
        titleLabel.text = "PRIORIDAD"        
        titleLabel.textColor = ThemeColors.text.withAlphaComponent(0.6)
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    private func setupOptions() {
        addSubview(stackH)
        
        stackH.axis = .horizontal
        stackH.distribution = .fillEqually
        stackH.alignment = .fill
        stackH.spacing = 4
        
        let options = Priority.allCases
        
        for option in options {
            let btn = TMButton()
            
            switch option {
            case .normal:
                btn.setTitle("Normal", for: .normal)
                btn.backgroundColor = .systemTeal
                btn.alpha = 0.3
                btn.tag = 0
            case .moderada:
                btn.setTitle("Moderada", for: .normal)
                btn.backgroundColor = .systemYellow
                btn.alpha = 0.3
                btn.tag = 1
            case .importante:
                btn.setTitle("Importante", for: .normal)
                btn.backgroundColor = .systemRed
                btn.alpha = 0.3
                btn.tag = 2
            }
            
            btn.layer.cornerRadius = 10
            btn.clipsToBounds = true
            btn.addTarget(self, action: #selector(priorityTapped(_:)), for: .touchUpInside)
            stackH.addArrangedSubview(btn)
        }
        
        stackH.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackH.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stackH.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackH.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackH.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    @objc private func priorityTapped(_ sender: UIButton) {
        for priorityButton in stackH.arrangedSubviews {
            priorityButton.alpha = 0.3
        }
        sender.alpha = 1
        self.currentPriority = sender.tag
    }
    
}
