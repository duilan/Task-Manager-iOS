//
//  TaskTableViewCell.swift
//  Task Manager
//
//  Created by Duilan on 25/10/21.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let cellID = "TaskTableViewCell"
    
    private let titleTask = TMTitleLabel(fontSize: 16, weight: .semibold, textAlignment: .left)
    private let creationTimeLabel = TMSubtitleLabel(fontSize: 12, weight: .regular, textAlignment: .left)
    private let stackTitles = UIStackView()
    private let priorityLabel = TMTagLabel()
    private let containerView = UIView()
    public  let doneButton = TMCheckBoxButton()
    public var doneButtonAction : (() -> ()) = {}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupContainer()
        setupCheckMarkButton()
        setupTitleAndCreateDateLabel()
        setupPriorityLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with task: Task) {
        titleTask.text = task.title
        creationTimeLabel.text = "Hace \( Date().countFrom(date: task.createAt!))"
        doneButton.isChecked = task.isDone
        let priority = Priority.allCases[Int(task.priority)]
        configurePriority(priority)
    }
    
    func configurePriority(_ priority: Priority) {
        // text
        priorityLabel.text = priority.rawValue
        // color
        switch priority {
        case .normal:
            priorityLabel.accentColor = .systemTeal
        case .moderada:
            priorityLabel.accentColor = .systemYellow
        case .importante:
            priorityLabel.accentColor = .systemRed
        }
    }
    
    @objc func doneButtonTapped(_ sender: TMCheckBoxButton) {
        doneButtonAction()
    }
    
    private func setup() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    private func setupContainer() {
        contentView.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.layer.cornerCurve = .circular
        containerView.clipsToBounds = true
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
    
    private func setupCheckMarkButton() {
        containerView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside )
        
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 30),
            doneButton.widthAnchor.constraint(equalToConstant: 30),
            doneButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            doneButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    private func setupTitleAndCreateDateLabel() {
        containerView.addSubview(stackTitles)
        stackTitles.addArrangedSubview(titleTask)
        stackTitles.addArrangedSubview(creationTimeLabel)
        titleTask.numberOfLines = 1
        creationTimeLabel.numberOfLines = 1
        
        stackTitles.axis = .vertical
        stackTitles.translatesAutoresizingMaskIntoConstraints = false
        // Contraints
        NSLayoutConstraint.activate([
            titleTask.heightAnchor.constraint(equalToConstant: 20),
            creationTimeLabel.heightAnchor.constraint(equalToConstant: 20),
            stackTitles.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackTitles.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 16),
            stackTitles.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupPriorityLabel() {
        containerView.addSubview(priorityLabel)
        NSLayoutConstraint.activate([
            priorityLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            priorityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            priorityLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
