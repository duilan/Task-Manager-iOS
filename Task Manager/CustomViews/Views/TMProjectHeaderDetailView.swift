//
//  TMProjectHeaderDetailView.swift
//  Task Manager
//
//  Created by Duilan on 10/11/21.
//

import UIKit

class TMProjectHeaderDetailView: UIView {
    
    private let contentStackView = UIStackView()
    private let titleLabel = TMTitleLabel(fontSize: 24, weight: .bold, textAlignment: .center, colorInverted: true)
    private let aliasLabel = TMTitleLabel(fontSize: 12, weight: .medium, textAlignment: .center, colorInverted: true)
    private let startDateTextField = TMDateField()
    private let endDateTextField = TMDateField()
    private let descTextView = TMTextView()
    private let buttonShowMore = TMButton()
    private var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupGradient()
        setupContentStack()
        setupAliasAndTitleLabel()
        setupDateTextFields()
        setupDescTextView()
        setupButtonShowMore()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with project: Project) {
        titleLabel.text = project.title
        aliasLabel.text = project.alias
        startDateTextField.setDefaultDate(project.startDate)
        endDateTextField.setDefaultDate(project.endDate)
        descTextView.text = project.desc
    }
    
    @objc func showMoreInfo(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            UIView.animate(withDuration: 0.3) {
                self.descTextView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.descTextView.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    self.descTextView.isHidden = true
                } completion: { _ in
                    self.descTextView.alpha = 1
                }
            }
        }
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
    }
    
    private func setupGradient() {
        gradientLayer = ThemeColors.createGradientLayer(colorSet: [ThemeColors.accentColor.darker(), ThemeColors.accentColor.lighter()])
        self.layer.insertSublayer(gradientLayer, at: 0) // resize frame at layoutSubviews()
    }
    
    
    private func setupContentStack() {
        self.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.distribution = .fill
        contentStackView.alignment = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])
    }
    
    private func setupAliasAndTitleLabel() {
        contentStackView.addArrangedSubview(aliasLabel)
        aliasLabel.numberOfLines = 1
        aliasLabel.text = "Subtitle"
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.setCustomSpacing(12, after: titleLabel)
        titleLabel.text = "Project Title"
        titleLabel.numberOfLines = 3
    }
    
    private func setupDateTextFields() {
        let hStack = UIStackView(arrangedSubviews: [startDateTextField,endDateTextField])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.distribution = .fillEqually
        hStack.alignment = .fill
        
        contentStackView.addArrangedSubview(hStack)
        contentStackView.setCustomSpacing(8, after: hStack)
        
        startDateTextField.title = "Fecha Inicio"
        startDateTextField.isEnabled = false
        startDateTextField.layer.cornerCurve = .continuous
        startDateTextField.layer.cornerRadius = 10
        startDateTextField.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        startDateTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        endDateTextField.title = "Fecha Termino"
        endDateTextField.isEnabled = false
        endDateTextField.layer.cornerCurve = .continuous
        endDateTextField.layer.cornerRadius = 10
        endDateTextField.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        endDateTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupDescTextView() {
        contentStackView.addArrangedSubview(descTextView)
        contentStackView.setCustomSpacing(8, after: descTextView)
        
        descTextView.title = "Descripción"
        descTextView.isScrollEnabled = false
        descTextView.isEditable = false
        descTextView.isHidden = true // need to press showMore button
        descTextView.layer.cornerCurve = .continuous
        descTextView.layer.cornerRadius = 10
        descTextView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        descTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
    }
    
    private func setupButtonShowMore() {
        self.addSubview(buttonShowMore)
        contentStackView.addArrangedSubview(buttonShowMore)
        
        buttonShowMore.backgroundColor = .none
        buttonShowMore.tintColor = .white // to SF icon
        // icon states
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .default)
        buttonShowMore.setImage(UIImage(systemName: "chevron.compact.down" ,withConfiguration: largeConfig), for: .normal)
        buttonShowMore.setImage(UIImage(systemName: "chevron.compact.up" ,withConfiguration: largeConfig), for: .selected)
        // target action
        buttonShowMore.addTarget(self, action: #selector(showMoreInfo(_:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds // resize gradient when view is expanded
    }
    
}
