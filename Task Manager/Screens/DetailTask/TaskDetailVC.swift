//
//  TaskDetailVC.swift
//  Task Manager
//
//  Created by Duilan on 14/12/21.
//

import UIKit

protocol TaskDetailProtocol: AnyObject {
    func taskDidUpdate()
}

class TaskDetailVC: UIViewController {
    
    private let formStackView = UIStackView()
    private let titleTextField = TMTextField()
    private let notesTextView = TMTextView()
    private let prioritiesView = TMPriorityOptionsView()
    private let saveButton = TMButton("Guardar cambios")
    private let closeButton = UIButton(type: .close)
    
    private var vm: TaskDetailVM!
    
    weak var delegate: TaskDetailProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBlurView()
        setupNavbarItems()
        setupContentView()
        setupTitleTextField()
        setupNotesTextView()
        setupPrioritiesView()
        setupSaveButton()
        setupCloseButton()
    }
    
    init(task: Task) {
        super.init(nibName: nil, bundle: nil)
        vm = TaskDetailVM(of: task)
        vm.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        definesPresentationContext = true
    }
    
    private func setupBlurView(){
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.frame = view.frame
        view.addSubview(blurView)
    }
    
    @objc private func saveButtonTapped() {      
        vm.taskName.value = titleTextField.text ?? ""
        vm.taskNotes.value = notesTextView.text ?? ""
        vm.taskPriority.value = prioritiesView.currentValue
        vm.updateDetailTask()
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
        formStackView.backgroundColor = .white
        formStackView.axis = .vertical
        formStackView.spacing = 4
        formStackView.isLayoutMarginsRelativeArrangement = true
        formStackView.layoutMargins = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        formStackView.translatesAutoresizingMaskIntoConstraints = false
        
        formStackView.layer.cornerRadius = 20
        formStackView.layer.cornerCurve = .continuous
        formStackView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            formStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            formStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            formStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            formStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    private func setupTitleTextField() {
        formStackView.addArrangedSubview(titleTextField)
        titleTextField.title = vm.taskName.title
        titleTextField.placeholder = vm.taskName.placeHolder
        titleTextField.text = vm.taskName.value
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupNotesTextView() {
        formStackView.addArrangedSubview(notesTextView)
        notesTextView.title = vm.taskNotes.title
        notesTextView.text = vm.taskNotes.value
        notesTextView.isScrollEnabled = false
        notesTextView.maximumNumberOfLines = 5
        notesTextView.layer.cornerRadius = 0
        notesTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
    }
    
    private func setupPrioritiesView() {
        formStackView.addArrangedSubview(prioritiesView)
        formStackView.setCustomSpacing(24, after: prioritiesView)
        prioritiesView.setPriority(option: vm.taskPriority.value)
    }
    
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.topAnchor.constraint(equalTo: formStackView.bottomAnchor, constant: 40).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.backgroundColor = .secondarySystemBackground
        closeButton.layer.cornerRadius = 30
        closeButton.addTarget(self, action: #selector(dismissThis), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 48),
            closeButton.widthAnchor.constraint(equalToConstant: 60),
            closeButton.heightAnchor.constraint(equalToConstant: 60),
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension  TaskDetailVC: TaskDetailDelegate {
    
    func taskDetailUpdated() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.taskDidUpdate()
        }
    }
    
    func validationError(error: Task.TaskError) {
        var msgError = ""
        switch error {
        case .emptyTitleisNotAllowed:
            msgError = "Agrega nombre a la tarea"
            titleTextField.becomeFirstResponder()
        }
        
        presentTMAlertVC(title: "", message: msgError, buttonTitle: "Entendido")
    }
}
