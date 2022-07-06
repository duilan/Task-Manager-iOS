//
//  CreateProjectVC.swift
//  Task Manager
//
//  Created by Duilan on 29/10/21.
//

import UIKit

class CreateProjectVC: UIViewController {
    
    private let formStackView = UIStackView()
    private let titleTextField = TMTextField()
    private let aliasTextField = TMTextField()
    private let startDateTextField = TMDateField()
    private let endDateTextField = TMDateField()
    private let descTextView = TMTextView()
    private let saveButton = TMButton("Guardar")
    private let colorPicker = TMColorPickerView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var colorOfProject = 0 // default blue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavbarItems()
        setupScrollView()
        setupFormStackView()
        setupTitleTextField()
        setupAliasTextField()
        setupDescTextView()
        setupDateTextFields()
        setupColorPicker()
        setupSaveButton()
    }
    
    private func setup() {
        title = "Nuevo Proyecto"
        view.backgroundColor = ThemeColors.backgroundPrimary
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode  = .always
    }
    
    private func setupNavbarItems() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode  = .always
        let btnItem = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = btnItem
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.alwaysBounceVertical = true
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0)
        ])
    }
    
    private func setupFormStackView() {
        contentView.addSubview(formStackView)
        formStackView.axis = .vertical
        formStackView.spacing = 4
        formStackView.translatesAutoresizingMaskIntoConstraints = false
        // Constraints
        NSLayoutConstraint.activate([
            formStackView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 16),
            formStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            formStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            formStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            //formStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
        ])
    }
    
    private func setupTitleTextField() {
        formStackView.addArrangedSubview(titleTextField)
        titleTextField.title = "Titulo"
        titleTextField.placeholder = "Titulo del proyecto"
        titleTextField.clearButtonMode = .whileEditing
        titleTextField.layer.cornerCurve = .continuous
        titleTextField.layer.cornerRadius = 10
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupAliasTextField() {
        formStackView.addArrangedSubview(aliasTextField)
        aliasTextField.title = "Subtitulo"
        aliasTextField.placeholder = "Subtitulo o alias"
        aliasTextField.clearButtonMode = .whileEditing
        aliasTextField.layer.cornerCurve = .continuous
        aliasTextField.layer.cornerRadius = 10
        aliasTextField.translatesAutoresizingMaskIntoConstraints = false
        aliasTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupDescTextView() {
        formStackView.addArrangedSubview(descTextView)        
        descTextView.title = "Descripción"
        descTextView.toolbarPlaceholder = "Descripción acerca del proyecto"
        descTextView.maximumNumberOfLines = 0
        descTextView.isScrollEnabled = false
        descTextView.layer.cornerCurve = .continuous
        descTextView.layer.cornerRadius = 10
        descTextView.translatesAutoresizingMaskIntoConstraints = false
        descTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
    }
    
    private func setupDateTextFields() {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 4
        hStack.distribution = .fillEqually
        formStackView.addArrangedSubview(hStack)
        
        hStack.addArrangedSubview(startDateTextField)
        startDateTextField.title = "Fecha Inicio"
        startDateTextField.setDefaultDate()
        startDateTextField.layer.cornerCurve = .continuous
        startDateTextField.layer.cornerRadius = 10
        startDateTextField.translatesAutoresizingMaskIntoConstraints = false
        startDateTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        hStack.addArrangedSubview(endDateTextField)
        endDateTextField.title = "Fecha Termino"
        endDateTextField.layer.cornerCurve = .continuous
        endDateTextField.layer.cornerRadius = 10
        endDateTextField.translatesAutoresizingMaskIntoConstraints = false
        endDateTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupColorPicker() {
        formStackView.addArrangedSubview(colorPicker)
        formStackView.setCustomSpacing(24, after: colorPicker)
        colorPicker.layer.cornerCurve = .continuous
        colorPicker.layer.cornerRadius = 10
        colorPicker.backgroundColor = .white
    }
    
    private func setupSaveButton() {
        formStackView.addArrangedSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func saveButtonTapped() {
        
        guard let titleValue = titleTextField.text, !titleValue.isEmpty else {
            titleTextField.becomeFirstResponder()
            return
        }
        guard let aliasValue = aliasTextField.text, !aliasValue.isEmpty else {
            aliasTextField.becomeFirstResponder()
            return
        }
        guard let startDate = startDateTextField.date else {
            startDateTextField.becomeFirstResponder()
            return
        }
        
        guard let endDate = endDateTextField.date else {
            endDateTextField.becomeFirstResponder()
            return
        }
        
        let descValue = descTextView.text
        let colorProject = colorPicker.indexColor
        
        CoreDataManager.shared.createProject(
            alias: aliasValue,
            title: titleValue,
            desc: descValue,
            startDate: startDate,
            endDate: endDate,
            color: colorProject) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
}
