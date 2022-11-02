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
    private let defaultIndexOption: Int = Priority.normal.value
    
    var indexOption: Int = 0 {
        didSet {
            guard let option = Priority(rawValue: indexOption) else { return }
            setPriority(option: option)
        }
    }
    
    private(set) var currentValue: Priority!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupTitle()
        setupOptions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPriority(option: Priority) {
        for priorityButton in stackH.arrangedSubviews {
            priorityButton.alpha = 0.3
            if priorityButton.tag == option.value {
                priorityButton.alpha = 1
                currentValue = option
            }
        }
    }
    
    func setTitle(text: String) {
        titleLabel.text = text.uppercased()
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
                btn.backgroundColor = .systemTeal
            case .moderada:
                btn.backgroundColor = .systemYellow
            case .importante:
                btn.backgroundColor = .systemRed
            }
            
            btn.setTitle(option.text, for: .normal)
            btn.alpha = 0.3
            btn.tag = option.value
            btn.layer.cornerRadius = 10
            btn.clipsToBounds = true
            btn.addTarget(self, action: #selector(priorityTapped(_:)), for: .touchUpInside)
            stackH.addArrangedSubview(btn)
        }
        
        // after all options are created, set the default option
        self.indexOption = defaultIndexOption
        
        stackH.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackH.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stackH.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackH.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackH.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    @objc private func priorityTapped(_ sender: UIButton) {
        indexOption = sender.tag
    }
    
}
