//
//  TaskTableViewCell.swift
//  Task Manager
//
//  Created by Duilan on 25/10/21.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let cellID = "TaskTableViewCell"
    
    private let titleTask = TMTitleLabel(fontSize: 14, weight: .medium, textAlignment: .left)
    private let notesTask = TMSubtitleLabel(fontSize: 12, weight: .regular, textAlignment: .left)
    private let creationTimeLabel = TMSubtitleLabel(fontSize: 11, weight: .light, textAlignment: .right)
    private let stackTitles = UIStackView()
    private let priorityLabel = TMTagLabel()
    private let containerView = UIView()
    public  let doneButton = TMCheckBoxButton()
    public var doneButtonAction : (() -> ()) = {}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        setupContainer()
        setupTitleAndCreateDateLabel()
        setupCheckMarkButton()
        setupPriorityLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with task: Task) {
        titleTask.text = task.title
        notesTask.text = task.notes
        creationTimeLabel.text = "Hace \( Date().countFrom(date: task.createAt!))"
        doneButton.isChecked = task.isDone
        let priority = Priority.allCases[Int(task.priority)]
        configurePriority(priority)
    }
    
    func configurePriority(_ priority: Priority) {
        // text
        priorityLabel.text = priority.value
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
        doneButton.backgroundColor = .white
        doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside )
        
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 30),
            doneButton.widthAnchor.constraint(equalToConstant: 30),
            doneButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -14),
            doneButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
        ])
    }
    
    private func setupTitleAndCreateDateLabel() {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // StackView
        containerView.addSubview(stackTitles)
        stackTitles.axis = .vertical
        stackTitles.translatesAutoresizingMaskIntoConstraints = false
        
        // Title
        stackTitles.addArrangedSubview(titleTask)
        titleTask.numberOfLines = 1
        stackTitles.setCustomSpacing(2, after: titleTask)
        // Notes
        stackTitles.addArrangedSubview(notesTask)
        notesTask.numberOfLines = 1
        stackTitles.setCustomSpacing(8, after: notesTask)
        // separator
        stackTitles.addArrangedSubview(separatorView)
        stackTitles.setCustomSpacing(8, after: separatorView)
        // Time
        stackTitles.addArrangedSubview(creationTimeLabel)
        creationTimeLabel.numberOfLines = 1
        
        // Contraints
        NSLayoutConstraint.activate([
            titleTask.heightAnchor.constraint(equalToConstant: 20),
            creationTimeLabel.heightAnchor.constraint(equalToConstant: 20),
            stackTitles.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackTitles.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackTitles.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupPriorityLabel() {
        containerView.addSubview(priorityLabel)
        NSLayoutConstraint.activate([
            priorityLabel.bottomAnchor.constraint(equalTo: stackTitles.bottomAnchor),
            priorityLabel.leadingAnchor.constraint(equalTo: stackTitles.leadingAnchor),
            priorityLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
}
