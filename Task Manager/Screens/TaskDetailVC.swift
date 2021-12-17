//
//  TaskDetailVC.swift
//  Task Manager
//
//  Created by Duilan on 14/12/21.
//

import UIKit

class TaskDetailVC: UIViewController {
    
    private let formStackView = UIStackView()
    private let titleTextField = TMTextField()
    private let notesTextView = TMTextView()
    private let prioritiesView = TMPriorityOptionsView()
    private let saveButton = TMButton("Guardar cambios")
    
    private let coredata = CoreDataManager.shared
    
    private var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavbarItems()
        setupContentView()
        setupTitleTextField()
        setupNotesTextView()
        setupPrioritiesView()
        setupSaveButton()
    }
    
    init(task: Task) {
        super.init(nibName: nil, bundle: nil)
        self.task = task
        titleTextField.text = task.title
        notesTextView.text = task.notes        
        prioritiesView.currentPriority = Int(task.priority)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.backgroundColor = ThemeColors.backgroundPrimary
        navigationItem.title = "Detalle"        
    }
    
    @objc private func saveButtonTapped() {
        
        guard let task = self.task else { return }
        
        guard let titleValue = titleTextField.text, !titleValue.isEmpty else {
            titleTextField.becomeFirstResponder()
            return
        }
        
        let notes = notesTextView.text
        let priorityID = prioritiesView.currentPriority
        
        task.title = titleValue
        task.notes = notes
        task.priority = Int64(priorityID)
        
        coredata.updateTask(with: task ) { [weak self] in
            print("Se actualizo")
            self?.dismissThis()
        }
        
    }
    
    @objc private func dismissThis() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupNavbarItems() {
        let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissThis))
        navigationItem.rightBarButtonItem = cancelButtonItem
    }
    
    private func setupContentView() {
        view.addSubview(formStackView)
        formStackView.axis = .vertical
        formStackView.spacing = 4
        formStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            formStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            formStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            formStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    private func setupTitleTextField() {
        formStackView.addArrangedSubview(titleTextField)
        titleTextField.title = "Nombre"
        titleTextField.placeholder = "Nombre de la tarea"
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.layer.cornerCurve = .continuous
        titleTextField.layer.cornerRadius = 10
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupNotesTextView() {
        formStackView.addArrangedSubview(notesTextView)
        notesTextView.title = "Notas"
        notesTextView.isScrollEnabled = false
        notesTextView.maximumNumberOfLines = 5
        notesTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
    }
    
    private func setupSaveButton() {
        formStackView.addArrangedSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupPrioritiesView() {
        formStackView.addArrangedSubview(prioritiesView)
        formStackView.setCustomSpacing(24, after: prioritiesView)
    }
    
}