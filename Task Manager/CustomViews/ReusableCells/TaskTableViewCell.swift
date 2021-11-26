//
//  TaskTableViewCell.swift
//  Task Manager
//
//  Created by Duilan on 25/10/21.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let cellID = "TaskTableViewCell"
    
    private let iconView = TMSquareIconView(withGradient: true)
    private let titleTask = TMTitleLabel(fontSize: 16, weight: .semibold, textAlignment: .left)
    private let subtitleTask = TMSubtitleLabel(fontSize: 12, weight: .regular, textAlignment: .left)
    private let stackTitles = UIStackView()
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupContainer()
        setupIconView()
        setupTitleAndSubtitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with task: Task) {
        titleTask.text = task.title
        #warning("Faltan atributos en el modelo del task ")
        subtitleTask.text = "Hace 2 Días"
    }
    
    private func setup() {
        backgroundColor = .clear
    }
    
    private func setupContainer() {
        contentView.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.layer.cornerCurve = .circular
        // shadow
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 2.0
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        // Contraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    private func setupIconView() {
        contentView.addSubview(iconView)
        iconView.systemNameIcon = "note.text"
        // Contraints
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            iconView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTitleAndSubtitle() {
        contentView.addSubview(stackTitles)
        stackTitles.addArrangedSubview(titleTask)
        stackTitles.addArrangedSubview(subtitleTask)
        titleTask.numberOfLines = 1
        subtitleTask.numberOfLines = 1
        
        stackTitles.axis = .vertical
        stackTitles.translatesAutoresizingMaskIntoConstraints = false
        // Contraints
        NSLayoutConstraint.activate([
            titleTask.heightAnchor.constraint(equalToConstant: 20),
            subtitleTask.heightAnchor.constraint(equalToConstant: 20),
            stackTitles.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackTitles.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            stackTitles.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
    }
    
}
