//
//  ProjectDetailVC.swift
//  Task Manager
//
//  Created by Duilan on 07/11/21.
//

import UIKit

class ProjectDetailVC: UIViewController {
    
    private var project: Project!
    private let detailHeaderView = TMProjectHeaderDetailView()
    
    private let taskVC = TMTasksListVC()
    private let taskVCContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupDetailHeaderView()
        setupTaskVContainer()
    }
    
    init(project: Project) {
        super.init(nibName: nil, bundle: nil)
        self.project = project
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        //navigationItem.title = project.title
        view.backgroundColor = ThemeColors.backgroundPrimary
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    private func setupDetailHeaderView() {
        view.addSubview(detailHeaderView)
        detailHeaderView.configure(with: project)
        
        detailHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailHeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            detailHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            detailHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  0),
            detailHeaderView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    
    private func setupTaskVContainer() {
        view.addSubview(taskVCContainer)
        add(childVC: taskVC, to: taskVCContainer)
        taskVC.tasksData = project.tasks?.allObjects as [Task]
        
        taskVCContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskVCContainer.topAnchor.constraint(equalTo: detailHeaderView.bottomAnchor),
            taskVCContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskVCContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskVCContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
