//
//  CreateTaskVC.swift
//  Task Manager
//
//  Created by Duilan on 19/11/21.
//

import UIKit

protocol CreateTaskProtocol: AnyObject {
    func taskAdded()
}

class CreateTaskVC: UIViewController {
    
    private let formStackView = UIStackView()
    private let titleTextField = TMTextField()
    private let notesTextView = TMTextView()
    private let prioritiesView = TMPriorityOptionsView()
    private let saveButton = TMButton("Guardar")
    
    private var vm: CreateTaskVM!
    
    weak var delegate: CreateTaskProtocol?
    
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
    
    init(project: Project) {
        super.init(nibName: nil, bundle: nil)
        vm = CreateTaskVM(project: project)
        vm.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func saveButtonTapped() {
        vm.taskName.value = titleTextField.text ?? ""
        vm.taskNotes.value = notesTextView.text ?? ""
        vm.taskPriority.value = prioritiesView.currentValue
        vm.createTask()
    }
    
    @objc private func dismissThis() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setup() {
        title = vm.screenTitle
        view.backgroundColor = ThemeColors.backgroundPrimary
        navigationController?.navigationBar.prefersLargeTitles = true
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
        titleTextField.title = vm.taskName.title
        titleTextField.placeholder = vm.taskName.placeHolder
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.layer.cornerCurve = .continuous
        titleTextField.layer.cornerRadius = 10
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupNotesTextView() {
        formStackView.addArrangedSubview(notesTextView)
        notesTextView.title = vm.taskNotes.title
        notesTextView.isScrollEnabled = false
        notesTextView.maximumNumberOfLines = 5
        notesTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
    }
    
    private func setupSaveButton() {
        formStackView.addArrangedSubview(saveButton)
        saveButton.backgroundColor = vm.colorProject.value
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupPrioritiesView() {
        formStackView.addArrangedSubview(prioritiesView)
        formStackView.setCustomSpacing(24, after: prioritiesView)
        prioritiesView.setTitle(text: vm.taskPriority.title)
        prioritiesView.setPriority(option: vm.taskPriority.value)
    }
    
}

extension CreateTaskVC: CreateTaskVMDelegate {
    func validationError(error: Task.TaskError) {
        
        var msgError = ""
        switch error {
        case .emptyTitleisNotAllowed:
            msgError = "Agrega nombre a la tarea"
            titleTextField.becomeFirstResponder()
        }
        
        presentTMAlertVC(title: "", message: msgError, buttonTitle: "Entendido")
    }
    
    func saveCompleted() {
        delegate?.taskAdded()
        dismissThis()
    }
    
}
