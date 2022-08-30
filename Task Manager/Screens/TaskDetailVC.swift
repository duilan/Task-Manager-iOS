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
    
    private let coredata = CoreDataManager.shared
    
    private var task: Task!
    
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
        self.task = task
        titleTextField.text = task.title
        notesTextView.text = task.notes        
        prioritiesView.indexOption = Int(task.priority)
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
        
        guard let task = self.task else { return }
        
        guard let titleValue = titleTextField.text, !titleValue.isEmpty else {
            titleTextField.becomeFirstResponder()
            return
        }
        
        let notes = notesTextView.text
        let priorityID = prioritiesView.indexOption
        
        if (task.title != titleValue || task.notes != notes || task.priority != Int64(priorityID) ) {
            
            task.title = titleValue
            task.notes = notes
            task.priority = Int64(priorityID)
            
            coredata.updateTask(with: task ) { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: {
                    self.delegate?.taskDidUpdate()
                })
            }
        } else {
            self.dismiss(animated: true)
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
        titleTextField.title = "Nombre"
        titleTextField.placeholder = "Nombre de la tarea"
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupNotesTextView() {
        formStackView.addArrangedSubview(notesTextView)
        notesTextView.title = "Notas"
        notesTextView.isScrollEnabled = false
        notesTextView.maximumNumberOfLines = 5
        notesTextView.layer.cornerRadius = 0
        notesTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
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
    
    private func setupPrioritiesView() {
        formStackView.addArrangedSubview(prioritiesView)
        formStackView.setCustomSpacing(24, after: prioritiesView)
    }
    
}
