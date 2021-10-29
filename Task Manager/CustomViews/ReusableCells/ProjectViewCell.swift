//
//  ProjectViewCell.swift
//  Task Manager
//
//  Created by Duilan on 17/10/21.
//

import UIKit

class ProjectViewCell: UICollectionViewCell {
    
    static let cellID = "ProjectViewCell"
    
    private let iconView = TMSquareIconView()
    private let aliasLabel = TMTitleLabel(fontSize: 12, weight: .semibold, colorInverted: true)
    private let titleLabel = TMTitleLabel(fontSize: 24, weight: .bold, colorInverted: true)
    private let createAtLabel = TMTitleLabel(fontSize: 12, weight: .regular, colorInverted: true)
    private let statusLabel = TMTitleLabel(fontSize: 12, weight: .regular, colorInverted: true)
    private let triangleShapesView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupBackgroundGradient()
        setupTriangeShapes()
        setupIcon()
        setupAliasLabel()
        setupDayLabelAndStatusLabel()
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with project: Project) {
        iconView.systemNameIcon = "wrench.and.screwdriver"
        aliasLabel.text = project.alias
        titleLabel.text = project.title
        #warning("Formatear la fecha de project")
        createAtLabel.text = "12/10/2021"
        statusLabel.text = project.status
    }
    
    private func setup() {
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }
    
    private func setupBackgroundGradient() {
        let startEndPointsGradient = (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1))
        self.addGradientBackground(colorSet: [ThemeColors.blueDark, ThemeColors.blueLight],
                                   startAndEndPoints: startEndPointsGradient)
    }
    
    func setupTriangeShapes() {
        let image = UIImage(named: "triangleShapes")?.withRenderingMode(.alwaysTemplate)
        addSubview(triangleShapesView)
        triangleShapesView.contentMode = .scaleAspectFill
        triangleShapesView.image = image
        triangleShapesView.tintColor = .black
        triangleShapesView.alpha = 0.5
        // Frame Size or Constraints
        triangleShapesView.frame = self.bounds
    }
    
    private func setupIcon() {
        contentView.addSubview(iconView)
        // Constraints
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            iconView.widthAnchor.constraint(equalToConstant: 36),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor, constant: 0)
        ])
    }
    
    private func setupAliasLabel() {
        contentView.addSubview(aliasLabel)        
        aliasLabel.numberOfLines = 1
        aliasLabel.textAlignment = .left
        // Constraints
        NSLayoutConstraint.activate([
            aliasLabel.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 0),
            aliasLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            aliasLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            aliasLabel.bottomAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 0),
        ])
    }
    
    func setupDayLabelAndStatusLabel() {
        let HStack = UIStackView()
        contentView.addSubview(HStack)
        HStack.axis = .horizontal
        HStack.distribution = .equalSpacing
        HStack.translatesAutoresizingMaskIntoConstraints = false
        HStack.addArrangedSubview(createAtLabel)
        HStack.addArrangedSubview(statusLabel)
        // Labels
        createAtLabel.numberOfLines = 1
        createAtLabel.textAlignment = .left
        statusLabel.numberOfLines = 1
        statusLabel.textAlignment = .right
        // Constraints
        NSLayoutConstraint.activate([
            HStack.heightAnchor.constraint(equalToConstant: 16),
            HStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            HStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            HStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 4
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: createAtLabel.topAnchor, constant: -8)
        ])
    }
    
}
