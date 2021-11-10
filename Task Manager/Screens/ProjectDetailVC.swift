//
//  ProjectDetailVC.swift
//  Task Manager
//
//  Created by Duilan on 07/11/21.
//

import UIKit

class ProjectDetailVC: UIViewController {
    
    private var project: Project!
    private let headerView = UIView()
    private let infoStack = UIStackView()
    private let titleField = TMTextField()
    private let aliasField = TMTextField()
    private let startDateField = TMDateField()
    private let endDateField = TMDateField()
    private let descText = TMTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupHeaderView()
    }
    
    init(project: Project) {
        super.init(nibName: nil, bundle: nil)
        self.project = project
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        navigationItem.title = project.title
        view.backgroundColor = ThemeColors.backgroundPrimary
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        //headerView.backgroundColor = .white
        
        //headerView.layer.cornerRadius = 32
        //headerView.layer.cornerCurve = .circular
        //headerView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        headerView.addSubview(infoStack)
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        infoStack.axis = .vertical
        infoStack.distribution = .fill
        infoStack.spacing = 4
        
        //infoStack.backgroundColor = .white
        infoStack.layer.cornerRadius = 32
        infoStack.layer.cornerCurve = .circular
        infoStack.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.topAnchor, constant: 8),
            infoStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 8),
            infoStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            infoStack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
        ])
        
        infoStack.addArrangedSubview(titleField)
        titleField.isEnabled = false
        titleField.title = "Proyecto"
        titleField.backgroundColor = .none
        titleField.text = project.title
        titleField.textColor = .white
        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        infoStack.addArrangedSubview(aliasField)
        aliasField.isEnabled = false
        aliasField.title = "Alias"
        aliasField.backgroundColor = .none
        aliasField.textColor = .white
        aliasField.text = project.alias
        aliasField.translatesAutoresizingMaskIntoConstraints = false
        aliasField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let datesStack = UIStackView(arrangedSubviews: [startDateField,endDateField])
        datesStack.axis = .horizontal
        datesStack.distribution = .fillEqually
        datesStack.spacing = 4
        infoStack.addArrangedSubview(datesStack)
        
        startDateField.isEnabled = false
        endDateField.isEnabled = false
        startDateField.title = "Fecha de Inicio"
        endDateField.title = "Fecha de Termino"
        startDateField.backgroundColor = .none
        startDateField.textColor = .white
        endDateField.backgroundColor = .none
        endDateField.textColor = .white
        startDateField.setDefaultDate(project.startDate ?? Date() )
        endDateField.setDefaultDate(project.endDate ?? Date())
        
        startDateField.translatesAutoresizingMaskIntoConstraints = false
        endDateField.translatesAutoresizingMaskIntoConstraints = false
        
        startDateField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        endDateField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        infoStack.addArrangedSubview(descText)
        descText.title = "Descripción"
        descText.text = project.desc
        descText.isEditable = false
        descText.backgroundColor = .none
        descText.textColor = .white
        
        descText.translatesAutoresizingMaskIntoConstraints = false
        descText.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.addGradientBackground(colorSet: [ThemeColors.accentColor.lighter(),ThemeColors.accentColor.darker()])
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            UIView.animate(withDuration: 0.3) { [unowned self] in
                titleField.isEnabled = true
                titleField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                titleField.textColor = ThemeColors.text
                titleField.layer.cornerRadius = 8
                
                aliasField.isEnabled = true
                aliasField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                aliasField.textColor = ThemeColors.text
                aliasField.layer.cornerRadius = 8
                
                startDateField.isEnabled = true
                startDateField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                startDateField.textColor = ThemeColors.text
                startDateField.layer.cornerRadius = 8
                
                endDateField.isEnabled = true
                endDateField.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                endDateField.textColor = ThemeColors.text
                endDateField.layer.cornerRadius = 8
                
                descText.isEditable = true
                descText.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                descText.textColor = ThemeColors.text
                descText.layer.cornerRadius = 8
            }
            print("modo edicion")
        } else {
            print("modo edicion desactivado")
            UIView.animate(withDuration: 0.3) { [unowned self] in
                titleField.isEnabled = false
                titleField.backgroundColor = .none
                titleField.textColor = .white
                
                aliasField.isEnabled = false
                aliasField.backgroundColor = .none
                aliasField.textColor = .white
                
                startDateField.isEnabled = false
                startDateField.backgroundColor = .none
                startDateField.textColor = .white
                
                endDateField.isEnabled = false
                endDateField.backgroundColor = .none
                endDateField.textColor = .white
                
                descText.isEditable = false
                descText.backgroundColor = .none
                descText.textColor = .white
            }
        }
    }
    
}
