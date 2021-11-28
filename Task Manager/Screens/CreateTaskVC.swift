//
//  CreateTaskVC.swift
//  Task Manager
//
//  Created by Duilan on 19/11/21.
//

import UIKit

protocol CreateTaskProtocol: class {
    func taskAdded()
}

class CreateTaskVC: UIViewController {
    
    private let formStackView = UIStackView()
    private let titleTextField = TMTextField()
    private let descTextView = TMTextView()
    private let saveButton = TMButton("Guardar")
    
    private var project: Project!
    private let coredata = CoreDataManager()
    
    weak var delegate: CreateTaskProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavbarItems()
        setupContentView()
        setupTitleTextField()
        setupDescTextView()
        setupSaveButton()
    }
    
    init(project: Project) {
        super.init(nibName: nil, bundle: nil)
        self.project = project        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func saveButtonTapped() {
        guard let titleValue = titleTextField.text, !titleValue.isEmpty else {
            titleTextField.becomeFirstResponder()
            return
        }
        let descValue = descTextView.text
        
        coredata.addTask(title: titleValue, desc: descValue, to: self.project) { [weak self] in
            guard let self = self else { return }
            
            self.dismiss(animated: true) {
                self.delegate?.taskAdded()
            }
        }
        
    }
    
    @objc private func dismissThis() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setup() {
        title = "Nueva Tarea"
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
        titleTextField.title = "Nombre"
        titleTextField.placeholder = "Nombre de la tarea"
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.layer.cornerCurve = .continuous
        titleTextField.layer.cornerRadius = 10
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupDescTextView() {
        formStackView.addArrangedSubview(descTextView)
        formStackView.setCustomSpacing(20, after: descTextView)
        descTextView.title = "Detalle de tarea"
        descTextView.isScrollEnabled = false
        descTextView.maximumNumberOfLines = 5
        descTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
    }
    
    private func setupSaveButton() {
        formStackView.addArrangedSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}