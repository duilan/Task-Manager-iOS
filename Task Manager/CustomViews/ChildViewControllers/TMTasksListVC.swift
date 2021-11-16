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
    
    private enum Section: String, CaseIterable {
        case pending = "Pendientes"
        case completed = "Completadas"
    }
    
    var tasksData: [Task] = [] {
        didSet {
            updateSnapshot(with: tasksData, animatingDifferences: false)
            preferredContentSize.height = tableViewHeight + tableView.contentInset.top + tableView.contentInset.bottom
        }
    }
    
    private var tableViewHeight: CGFloat {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTable()
        setupDataSource()
        updateSnapshot(with: tasksData, animatingDifferences: false)
    }
    
    private func setup() {
        view.backgroundColor = ThemeColors.backgroundPrimary
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.rowHeight = 80
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize.height = tableViewHeight + tableView.contentInset.top + tableView.contentInset .bottom
    }
    
    private func setupDataSource() {
        dataSource = TaskDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.cellID, for: indexPath) as? TaskTableViewCell else {
                return TaskTableViewCell()
            }
            cell.configure(with: item)
            return cell
        })
    }
    
    private func updateSnapshot(with tasks: [Task], animatingDifferences: Bool = true) {
        var snapshopt = TaskSnapshot()
        
        let pendingTasks = tasks.filter { $0.status == "Pendiente" }
        let completedTasks = tasks.filter { $0.status == "Completada" }
        
        snapshopt.appendSections([.pending,.completed])
        snapshopt.appendItems(pendingTasks, toSection: .pending)
        snapshopt.appendItems(completedTasks, toSection: .completed)
        dataSource.apply(snapshopt, animatingDifferences: animatingDifferences)
    }
}

extension TMTasksListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let InSection = Section.allCases[section]
        let headerView = TMSectionHeaderView()
        
        switch InSection {
        case .pending :
            headerView.configure(title: InSection.rawValue.uppercased())
        case .completed:
            headerView.configure(title: InSection.rawValue.uppercased())
        }
        return headerView
    }
    
    
}
