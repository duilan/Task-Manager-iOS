//
//  TMTasksListVC.swift
//  Task Manager
//
//  Created by Duilan on 18/10/21.
//

import UIKit

class TMTasksListVC: UIViewController {
    
    private typealias TaskDataSource = UITableViewDiffableDataSource<Section,Task>
    private typealias TaskSnapshot = NSDiffableDataSourceSnapshot<Section, Task>
    
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: TaskDataSource!
    private let emptyView = TMEmptyView(message: "Agrega algunas tareas 🎯 \n al proyecto")
    private var project: Project?
    
    private enum Section: String, CaseIterable {
        case pending = "Pendientes"
        case completed = "Completadas"
    }
    
    private var tableViewHeight: CGFloat {
        tableView.setNeedsLayout()
        return tableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTable()
        setupDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculatePreferredContentSize()
    }
    
    func setProject(_ project: Project?) {
        self.project = project
        
        if project != nil {
            updateData(animatingDifferences: false)
        } else {
            updateSnapshot(with: [], animatingDifferences: false)
        }
    }
    
    func contextMenuConfigurationActions(indexPath: IndexPath) -> UIContextMenuConfiguration {
        let context =  UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (menuElement) -> UIMenu? in
            
            let deleteAction =
                UIAction(title: NSLocalizedString("Eliminar Tarea", comment: ""),
                         image: UIImage(systemName: "trash"),
                         attributes: .destructive) { action in
                    guard let task = self.dataSource.itemIdentifier(for: indexPath) else { return }
                    CoreDataManager.shared.delete(task) {
                        // update task data
                        self.updateData()
                    }
                }
            
            return UIMenu(title: "OPCIONES", options: .displayInline , children: [deleteAction])
        }
        return context
    }
    
    private func calculatePreferredContentSize() {
        preferredContentSize.height = tableViewHeight + tableView.contentInset.top + tableView.contentInset.bottom
    }
    
    private func setup() {
        view.backgroundColor = ThemeColors.backgroundPrimary
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.backgroundColor = ThemeColors.backgroundPrimary
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.cellID)
        //registrar celdas
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func updateData(animatingDifferences: Bool = true){
        guard let currentProject = self.project else { return }
        
        CoreDataManager.shared.fetchTasksOf(currentProject) { [weak self] (tasks) in
            self?.updateSnapshot(with: tasks, animatingDifferences: animatingDifferences)
        }
    }
    
    private func setupDataSource() {
        dataSource = TaskDataSource(tableView: tableView, cellProvider: { [weak self] (tableView, indexPath, item) -> UITableViewCell? in
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.cellID, for: indexPath) as? TaskTableViewCell else {
                return TaskTableViewCell()
            }
            cell.configure(with: item)
            cell.doneButtonAction = {
                item.isDone = !item.isDone
                item.doneAt = Date() // current date
                CoreDataManager.shared.updateTask(with: item) { [weak self] in
                    self?.updateData()
                }
            }
            return cell
        })
    }
    
    private func updateSnapshot(with tasks: [Task], animatingDifferences: Bool = true) {
        var snapshopt = TaskSnapshot()
        
        defer {
            dataSource.apply(snapshopt, animatingDifferences: animatingDifferences) { [weak self] in
                self?.calculatePreferredContentSize()
            }
        }
        
        tableView.backgroundView = nil
        if tasks.isEmpty && project != nil {
            tableView.backgroundView = emptyView
            return
        }
        
        let pendingTasks = tasks.filter { $0.isDone == false }
        let completedTasks = tasks.filter { $0.isDone == true }
        
        var sectionsData: [(Section,[Task])] = [] // tuple
        
        if !pendingTasks.isEmpty {
            sectionsData.append((.pending, pendingTasks))
        }
        
        if !completedTasks.isEmpty {
            sectionsData.append((.completed, completedTasks))
        }
        
        for section in sectionsData {
            // section.0 = section category, section.1 = [Tasks]
            snapshopt.appendSections([section.0])
            snapshopt.appendItems(section.1, toSection: section.0)
        }
    }
}

extension TMTasksListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        guard let task = dataSource.itemIdentifier(for: indexPath) else { return }
        let taskDetailVC = TaskDetailVC(task: task)
        taskDetailVC.delegate = self
        taskDetailVC.modalPresentationStyle = .overCurrentContext
        taskDetailVC.modalTransitionStyle = .crossDissolve
        present(taskDetailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = TMSectionHeaderView()
        let currentSection = dataSource.snapshot().sectionIdentifiers[section]
        headerView.configure(title: currentSection.rawValue.uppercased())
        return headerView
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        contextMenuConfigurationActions(indexPath: indexPath)
    }
    
}

extension TMTasksListVC: TaskDetailProtocol {
    func taskDidUpdate() {
        self.updateData(animatingDifferences: false)
    }
}

