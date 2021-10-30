//
//  CreateProjectVC.swift
//  Task Manager
//
//  Created by Duilan on 29/10/21.
//

import UIKit

class CreateProjectVC: UIViewController {
    
    private let headerView = UIStackView()
    private let aliasTextField = UITextField()
    private let titleTextField = UITextField()
    private let descTextField = UITextField()
    private let saveButton = UIButton()
    
    private let coredata = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupHeaderView()
        setupSaveButton()
    }
    
    private func setup() {
        view.backgroundColor = ThemeColors.backgroundPrimary
        title = "Añadir Proyecto"
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        headerView.clipsToBounds = true
        headerView.axis = .vertical
        headerView.translatesAutoresizingMaskIntoConstraints = false
        // Alias TextField
        headerView.addArrangedSubview(aliasTextField)
        aliasTextField.placeholder = "Alias"
        aliasTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // title TextField
        headerView.addArrangedSubview(titleTextField)
        titleTextField.placeholder = "Titulo"
        titleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // Description TextField
        headerView.addArrangedSubview(descTextField)
        descTextField.placeholder = "Descripcion"
        descTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupSaveButton() {
        headerView.addArrangedSubview(saveButton)
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.setTitle("Guardar", for: .normal)
        saveButton.setTitleColor(ThemeColors.title, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped() {
        
        guard let aliasValue = aliasTextField.text, !aliasValue.isEmpty else { return}
        guard let titleValue = titleTextField.text, !titleValue.isEmpty else { return }
        guard let descValue = descTextField.text else { return }
        
        coredata.createProject(alias: aliasValue, title: titleValue, desc: descValue) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
