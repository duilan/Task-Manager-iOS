//
//  TMSectionHeaderView.swift
//  Task Manager
//
//  Created by Duilan on 15/11/21.
//

import UIKit

class TMSectionHeaderView: UIView {
    
    private let title = TMTitleLabel(fontSize: 12, weight: .bold, textAlignment: .left)
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupBlurView()
        setupTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        self.title.text = title
    }
    
    private func setup() {
        backgroundColor = .clear
    }
    
    private func setupBlurView() {
        addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])
    }
    
    private func setupTitle() {
        addSubview(title)
        title.alpha = 0.6
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
