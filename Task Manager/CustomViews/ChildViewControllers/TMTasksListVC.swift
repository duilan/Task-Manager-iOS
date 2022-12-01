//
//  TMTasksListVC.swift
//  Task Manager
//
//  Created by Duilan on 18/10/21.
//

import UIKit

class TMTasksListVC: UIViewController {
    
    private typealias TaskDataSource = UITableViewDiffableDataSource<TaskListViewModel.Section,Task>
    private typealias TaskSnapshot = NSDiffableDataSourceSnapshot<TaskListViewModel.Section, Task>
    
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: TaskDataSource!
    
    private let vm = TaskListViewModel()
    
    private var tableViewHeight: CGFloat {
        tableView.layoutIfNeeded()
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
    
    private func setup() {
        view.backgroundColor = ThemeColors.backgroundPrimary
        vm.delegate = self
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
        //registrar celdas
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.cellID)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupDataSource() {
        dataSource = TaskDataSource(tableView: tableView, cellProvider: { [weak self] (tableView, indexPath, item) -> UITableViewCell? in
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.cellID, for: indexPath) as? TaskTableViewCell else {
                return TaskTableViewCell()
            }
            cell.configure(with: item)
            cell.doneButtonAction = { [weak self] in
                self?.vm.toggleDoneStatus(of: item)
            }
            return cell
        })
    }
    
    func setProject(_ project: Project?) {
        vm.projectID = project?.id
        vm.loadTasks()
    }
    
    func refreshList(){
        vm.loadTasks()
    }
    
    private func updateSnapshot(animated: Bool = true) {
        var snapshot = TaskSnapshot()
        
        for list in vm.taskList {
            snapshot.appendSections([list.section])
            snapshot.appendItems(list.tasks, toSection: list.section)
        }
        
        dataSource.defaultRowAnimation = .fade
        dataSource.apply(snapshot, animatingDifferences: animated) { [weak self] in
            self?.calculatePreferredContentSize()
        }
    }
    
    private func checkForEmptyView() {
        let emptyView = TMEmptyView(message: "Agrega algunas tareas 🎯 \n al proyecto")
        tableView.backgroundView = vm.taskList.isEmpty && vm.projectID != nil ? emptyView: nil
    }
    
    private func showDetail(of task: Task) {
        let taskDetailVC = TaskDetailVC(task: task)
        taskDetailVC.delegate = self
        taskDetailVC.modalPresentationStyle = .overCurrentContext
        taskDetailVC.modalTransitionStyle = .crossDissolve
        showDetailViewController(taskDetailVC, sender: self)
    }
    
    private func contextMenuConfigurationActions(indexPath: IndexPath) -> UIContextMenuConfiguration {
        let context =  UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (menuElement) -> UIMenu? in
            
            let deleteAction =
                UIAction(title: NSLocalizedString("Eliminar Tarea", comment: ""),
                         image: UIImage(systemName: "trash"),
                         attributes: .destructive) { action in
                    guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return }
                    self.vm.delete(task: item)
                }
            
            return UIMenu(title: "OPCIONES", options: .displayInline , children: [deleteAction])
        }
        return context
    }
    
    private func calculatePreferredContentSize() {
        preferredContentSize.height = tableViewHeight + tableView.contentInset.top + tableView.contentInset.bottom
    }
    
}

// MARK: - UITableViewDelegate
extension TMTasksListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let task = dataSource.itemIdentifier(for: indexPath) else { return }
        showDetail(of: task)
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

// MARK: - TaskDetailProtocol
extension TMTasksListVC: TaskDetailProtocol {
    func taskDidUpdate() {
        self.refreshList()
    }
}

// MARK: - TaskListViewModelDelegate
extension TMTasksListVC: TaskListViewModelDelegate {
    func didLoadData() {
        checkForEmptyView()
        updateSnapshot()
    }
}
