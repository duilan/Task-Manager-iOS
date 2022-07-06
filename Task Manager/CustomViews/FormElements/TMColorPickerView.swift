//
//  TMColorPickerView.swift
//  Task Manager
//
//  Created by Duilan on 25/06/22.
//

import UIKit

class TMColorPickerView: UIView {
    
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let HStack = UIStackView()
    
    private(set) var indexColor: Int = 0 {
        didSet {
            self.showColorSelected()
        }
    }
    
    private let colorTopBottomPadding: CGFloat = 20
    private let colorHeight: CGFloat = 35
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupTitleLabel()
        setupScrollView()
        setupHStack()
        configureColorOptions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        self.clipsToBounds = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: colorHeight + colorTopBottomPadding)
        ])
    }
    
    private func setupHStack() {
        scrollView.addSubview(HStack)
        HStack.axis = .horizontal
        HStack.alignment = .center
        HStack.distribution = .fillEqually
        HStack.spacing = 20
        HStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            HStack.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            HStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            HStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15),
            HStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.text = "Color".uppercased()
        titleLabel.textColor = ThemeColors.title.withAlphaComponent(0.6)
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 15),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
    
    private func configureColorOptions() {
        // crea lista de colores existentes eb el model
        ProjectColors.allCases.forEach { (color) in
            let btnOption = UIButton()
            HStack.addArrangedSubview(btnOption)
            btnOption.backgroundColor = color.value // uicolor
            btnOption.tintColor = .white
            btnOption.layer.opacity = 0.3
            btnOption.tag = color.rawValue // int, sera indexColor para indetificar el color
            
            btnOption.clipsToBounds = true
            btnOption.layer.cornerRadius = colorHeight / 2
            btnOption.translatesAutoresizingMaskIntoConstraints = false
            btnOption.widthAnchor.constraint(equalToConstant: colorHeight).isActive = true
            btnOption.heightAnchor.constraint(equalTo: btnOption.widthAnchor).isActive = true
            //tap action
            btnOption.addTarget(self, action: #selector(colorTapped(_:)), for: .touchUpInside)
        }
        //set default color selected
        indexColor = 0
    }
    
    @objc private func colorTapped(_ btn: UIButton) {
        indexColor = btn.tag
    }
    
    private func showColorSelected() {
        
        guard let btnOptions = HStack.arrangedSubviews as? [UIButton] else { return }
        
        // remove checkmark image of all options
        btnOptions.forEach { (btn) in
            UIView.animate(withDuration: 0.1) {
                btn.setImage(nil, for: .normal)
                btn.layer.opacity = 0.3
                btn.transform = .identity
            }
        }
        // set checkmarkl only to the  color tapped
        UIView.animate(withDuration: 0.25) {
            btnOptions[self.indexColor].setImage(UIImage(systemName: "checkmark"), for: .normal)
            btnOptions[self.indexColor].layer.opacity = 1
            btnOptions[self.indexColor].transform = .init(scaleX: 1.1, y: 1.1)
        }
    }
    
}
