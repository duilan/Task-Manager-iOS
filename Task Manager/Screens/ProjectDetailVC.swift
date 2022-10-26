//
//  ProjectDetailVC.swift
//  Task Manager
//
//  Created by Duilan on 07/11/21.
//

import UIKit

class ProjectDetailVC: UIViewController {
    
    private var project: CDProject!
    private let detailHeaderView = TMProjectHeaderDetailView()
    private let addFloatButton = TMCircleButton()
    
    private let taskListVC = TMTasksListVC()
    private let taskListContainer = UIView()
    
    private let coredata = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupDetailHeaderView()
        setupTaskVContainer()
        setupAddFloatButton()
        updateTasksListProject()
    }
    
    init(project: CDProject) {
        super.init(nibName: nil, bundle: nil)
        self.project = project
        
        guard let color = ProjectColors(rawValue: Int(project.color))?.value else { return }
        addFloatButton.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateTasksListProject() {
        self.taskListVC.setProject(project)
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
        view.addSubview(taskListContainer)
        add(childVC: taskListVC, to: taskListContainer)
        
        taskListContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskListContainer.topAnchor.constraint(equalTo: detailHeaderView.bottomAnchor),
            taskListContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskListContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskListContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func showAddTaskVC() {
        let taskVC = CreateTaskVC(project: project)
        taskVC.delegate = self
        let nav = UINavigationController(rootViewController: taskVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    private func setupAddFloatButton() {
        view.addSubview(addFloatButton)
        addFloatButton.setSystemIcon(name: "pencil", pointSize: 25)
        addFloatButton.addTarget(self, action: #selector(showAddTaskVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            addFloatButton.heightAnchor.constraint(equalToConstant: 60),
            addFloatButton.widthAnchor.constraint(equalToConstant: 60),
            addFloatButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30),
            addFloatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
}

extension ProjectDetailVC: CreateTaskProtocol {
    func taskAdded() {
        self.updateTasksListProject()
    }
}
