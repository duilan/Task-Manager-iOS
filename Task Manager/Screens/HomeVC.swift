//
//  HomeVC.swift
//  Task Manager
//
//  Created by Duilan on 08/10/21.
//

import UIKit
import BetterSegmentedControl

class HomeVC: UIViewController {
    
    private let welcomeHeader = TMWelcomeHeaderView()
    private let segmentedControl = BetterSegmentedControl()
    private let projectsVC = TMProjectsVC()
    private var projectsData: [Project] = []
    private let taskVC = TMTasksListVC()
    private var tableHeight: NSLayoutConstraint!
    // 0 : InProgress, 1:Completed
    private var segmentIndex: Int = 0
    private var currentProject: Project? {
        didSet {
            taskVC.setProject(currentProject)
        }
    }
    
    private let coredata = CoreDataManager.shared
    
    //ScrollView Container
    let scrollView = UIScrollView()
    let stackContentView = UIStackView()
    
    // View Containers
    let headerContainer = UIView()
    let segmentedControlContainer = UIView()
    let projectsVCContainer = UIView()
    let tasksVCContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationButtonItems()
        setupScrollViewWithStackContainer()
        setupWelcomeHeader()
        setupSegmentedControl()
        setupChildProjectsVC()
        setupChildTasksVC()
        setDefaultSegmentSelection()
        updateProjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProjects()
    }
    
    private func setDefaultSegmentSelection() {
        segmentedControl.setIndex(0, animated: false, shouldSendValueChangedEvent: true)
    }
    
    private func updateProjects() {
        coredata.fetchAllProjects { [weak self] (projects) in
            guard let self = self else { return }
            self.projectsData = projects.map({ $0.toDomainModel() })
            self.filterProjectData()
        }
        
        taskVC.refreshList()
    }
    
    private func filterProjectData() {
        switch self.segmentIndex {
        case 0 :
            // show just in progress projects
            self.projectsVC.projectsData = projectsData.filter({ (project)  in
                return project.status == .inProgress
            })
        case 1 :
            // show just complete projects
            projectsVC.projectsData = projectsData.filter({ (project)  in
                return project.status == .completed
            })
        default:
            //no filter data
            projectsVC.projectsData = projectsData
        }
    }
    
    @objc private func GoToCreateProjectVC() {
        let createProjectVC = CreateProjectVC()
        createProjectVC.delegate = self
        navigationController?.pushViewController(createProjectVC, animated: true)
    }
    
    private func setup() {
        view.backgroundColor = ThemeColors.backgroundPrimary
        navigationItem.title = "Proyectos"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode  = .never
    }
    
    private func setupNavigationButtonItems() {
        let userImageSymbol = UIImage(systemName: "person.circle.fill")
        let addImageSymbol = UIImage(systemName: "plus")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: userImageSymbol, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: addImageSymbol, style: .plain, target: self, action: #selector(GoToCreateProjectVC))
    }
    
    private func setupScrollViewWithStackContainer() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackContentView)
        stackContentView.axis = .vertical
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackContentView.translatesAutoresizingMaskIntoConstraints = false
        // Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            stackContentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            stackContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            stackContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            stackContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            stackContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0),
            
        ])
    }
    
    private func setupWelcomeHeader() {
        stackContentView.addArrangedSubview(headerContainer)
        stackContentView.setCustomSpacing(8, after: headerContainer)
        headerContainer.addSubview(welcomeHeader)
        welcomeHeader.title = "Hola Adrián"
        NSLayoutConstraint.activate([
            headerContainer.heightAnchor.constraint(equalToConstant: 50),
            welcomeHeader.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            welcomeHeader.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
            welcomeHeader.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),
            welcomeHeader.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor)
        ])
    }
    
    private func setupSegmentedControl() {
        stackContentView.addArrangedSubview(segmentedControlContainer)
        segmentedControlContainer.addSubview(segmentedControl)
        segmentedControl.cornerRadius = 22.5
        segmentedControl.backgroundColor = #colorLiteral(red: 0.6156862745, green: 0.6156862745, blue: 0.6156862745, alpha: 0.08)
        segmentedControl.addTarget(self, action: #selector(segmentIndexChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure BettersegmentedControl segmets
        segmentedControl.segments = LabelSegment.segments(
            withTitles: ["En Progreso", "Completados"],
            normalFont: .systemFont(ofSize: 12.0, weight: .regular),
            normalTextColor: .lightGray,
            selectedFont: .systemFont(ofSize: 12.0, weight: .bold),
            selectedTextColor: ThemeColors.title)
        
        // Constraints
        NSLayoutConstraint.activate([
            segmentedControlContainer.heightAnchor.constraint(equalToConstant: 45),
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlContainer.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlContainer.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: segmentedControlContainer.trailingAnchor, constant: -16),
            segmentedControl.bottomAnchor.constraint(equalTo: segmentedControlContainer.bottomAnchor)
        ])
    }
    
    private func setupChildProjectsVC() {
        projectsVC.delegate = self
        stackContentView.addArrangedSubview(projectsVCContainer)
        add(childVC: projectsVC, to: projectsVCContainer)
        
        projectsVCContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            projectsVCContainer.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupChildTasksVC() {
        stackContentView.addArrangedSubview(tasksVCContainer)
        add(childVC: taskVC, to: tasksVCContainer)
        tableHeight =  tasksVCContainer.heightAnchor.constraint(equalToConstant: 400)
        taskVC.view.translatesAutoresizingMaskIntoConstraints = false
        tasksVCContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableHeight,
            taskVC.view.topAnchor.constraint(equalTo: tasksVCContainer.topAnchor),
            taskVC.view.leadingAnchor.constraint(equalTo: tasksVCContainer.leadingAnchor),
            taskVC.view.trailingAnchor.constraint(equalTo: tasksVCContainer.trailingAnchor),
            taskVC.view.bottomAnchor.constraint(equalTo: tasksVCContainer.bottomAnchor)
        ])
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        
        guard let container = container as? TMTasksListVC  else { return }
        let contentHeight = container.preferredContentSize.height
        
        tableHeight.constant = contentHeight < 150 ? 150 : contentHeight
    }
    
    @objc private func segmentIndexChanged(_ sender: BetterSegmentedControl) {
        segmentIndex = sender.index
        filterProjectData()
        
    }
}

extension HomeVC: TMProjectsProtocol {
    func projectDidChange(project: Project?) {
        currentProject = project
    }
    
    func projectDeleted() {
        updateProjects()
    }
    
    func projectUpdated() {
        updateProjects()
    }
}

extension HomeVC: CreateProjectProtocol {
    func projectAdded() {
        updateProjects()
        segmentedControl.setIndex(0, animated: false, shouldSendValueChangedEvent: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.projectsVC.animateToStartItem()
        }
    }
}
