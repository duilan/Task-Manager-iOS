//
//  TMColorPickerView.swift
//  Task Manager
//
//  Created by Duilan on 25/06/22.
//

import UIKit

class TMColorPickerView: UIView {
    
    private let stackH = UIStackView()
    
    private(set) var indexColor: Int = 0 {
        didSet {
            self.selectColorOption()
        }
    }
    
    var defaultHeight: CGFloat = 40
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: .zero, height: defaultHeight)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        configureColorOptions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(stackH)
        stackH.axis = .horizontal
        stackH.alignment = .center
        stackH.distribution = .fillEqually
        stackH.spacing = 20
        stackH.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackH.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackH.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func configureColorOptions() {
        // crea lista de colores existentes eb el model
        ProjectColors.allCases.forEach { (color) in
            let btnOption = UIButton(frame: .zero)
            stackH.addArrangedSubview(btnOption)
            btnOption.backgroundColor = color.value // uicolor
            btnOption.tintColor = .white
            btnOption.layer.opacity = 0.3
            btnOption.tag = color.rawValue // int que se almacenara en coredata
            
            btnOption.clipsToBounds = true
            btnOption.layer.cornerRadius = defaultHeight/2
            btnOption.translatesAutoresizingMaskIntoConstraints = false
            btnOption.heightAnchor.constraint(equalToConstant: defaultHeight).isActive = true
            btnOption.widthAnchor.constraint(equalToConstant: defaultHeight).isActive = true
            //tap action
            btnOption.addTarget(self, action: #selector(colorTapped(_:)), for: .touchUpInside)
        }
        
        //set default color selected
        indexColor = 0
    }
    
    private func selectColorOption() {
        
        guard let btnOptions = stackH.arrangedSubviews as? [UIButton] else { return }
        
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
    
    @objc private func colorTapped(_ btn: UIButton) {
        indexColor = btn.tag
    }
    
}
