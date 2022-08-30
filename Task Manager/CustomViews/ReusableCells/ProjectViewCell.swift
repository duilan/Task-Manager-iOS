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
    private let startDateLabel = TMTitleLabel(fontSize: 10, weight: .regular, colorInverted: true)
    private let endDateLabel = TMTitleLabel(fontSize: 10, weight: .regular, colorInverted: true)
    private let statusLabel = TMTitleLabel(fontSize: 10, weight: .regular, colorInverted: true)
    private let triangleShapesView = UIImageView()
    private let dateFormatterGet = DateFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupTriangeShapes()
        setupIcon()
        setupAliasAndStatusLabel()
        setupStartAndEndDateLabel()
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with project: Project) {
        setupBackgroundGradient(numberColor: Int(project.color))
        iconView.systemNameIcon = "wrench.and.screwdriver"
        aliasLabel.text = project.alias
        titleLabel.text = project.title
        dateFormatterGet.dateFormat = "d MMM yyyy"
        startDateLabel.text = "Del \(dateFormatterGet.string(from: project.startDate))"
        endDateLabel.text = "Hasta \(dateFormatterGet.string(from: project.endDate))"
        statusLabel.text = project.status
    }
    
    private func setup() {
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }
    
    private func setupBackgroundGradient(numberColor: Int = 0 ) {
        let color = ProjectColors(rawValue: numberColor) ?? .blue
        let startEndPointsGradient = (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1))
        self.addGradientBackground(colorSet: [color.value.darker(), color.value.lighter()],
                                   startAndEndPoints: startEndPointsGradient)
    }
    
    private func setupTriangeShapes() {
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
    
    private func setupAliasAndStatusLabel() {
        contentView.addSubview(aliasLabel)
        contentView.addSubview(statusLabel)
        
        aliasLabel.numberOfLines = 1
        aliasLabel.textAlignment = .left
        
        statusLabel.numberOfLines = 1
        statusLabel.textAlignment = .left
        
        // Constraints
        NSLayoutConstraint.activate([
            aliasLabel.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 0),
            aliasLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            aliasLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            aliasLabel.heightAnchor.constraint(equalToConstant: 20),
            
            statusLabel.topAnchor.constraint(equalTo: aliasLabel.bottomAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: aliasLabel.leadingAnchor,constant: 0),
            statusLabel.trailingAnchor.constraint(equalTo: aliasLabel.trailingAnchor, constant: 0),
            statusLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    private func setupStartAndEndDateLabel() {
        let HStack = UIStackView()
        contentView.addSubview(HStack)
        HStack.axis = .horizontal
        HStack.distribution = .equalSpacing
        HStack.translatesAutoresizingMaskIntoConstraints = false
        HStack.addArrangedSubview(startDateLabel)
        HStack.addArrangedSubview(endDateLabel)
        // Labels
        startDateLabel.numberOfLines = 1
        startDateLabel.textAlignment = .left
        
        endDateLabel.numberOfLines = 1
        endDateLabel.textAlignment = .right
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
            titleLabel.bottomAnchor.constraint(equalTo: startDateLabel.topAnchor, constant: -8)
        ])
    }
    
}
