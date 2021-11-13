//
//  TMTasksListVC.swift
//  Task Manager
//
//  Created by Duilan on 18/10/21.
//

import UIKit

class TMTasksListVC: UIViewController {
    
    var tableView: UITableView!    
    var dataSource: UITableViewDiffableDataSource<Section,Task>!
    var tasksData: [Task] = [] {
        didSet {
            updateSnapshot(with: tasksData, animatingDifferences: false)
            preferredContentSize.height = tableViewHeight + tableView.contentInset.top + tableView.contentInset .bottom
        }
    }
    
    enum Section:String, Hashable {
        case main = "Tareas"
    }
    
    var tableViewHeight: CGFloat {
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
    
    func setup() {
        view.backgroundColor = ThemeColors.backgroundPrimary
    }
    
    func setupTable() {
        tableView = UITableView(frame: .zero, style: .plain)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 32, right: 0)
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
    
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section,Task>(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            guard  let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.cellID, for: indexPath) as? TaskTableViewCell else {
                return TaskTableViewCell()
            }
            cell.configure(with: item)
            return cell
        })
    }
    
    func updateSnapshot(with tasks: [Task], animatingDifferences: Bool = true) {
        var snapshopt = NSDiffableDataSourceSnapshot<Section, Task>()
        snapshopt.appendSections([.main])
        snapshopt.appendItems(tasks, toSection: .main)
        dataSource.apply(snapshopt, animatingDifferences: animatingDifferences)
    }
}

extension TMTasksListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        let vc = TMTasksListVC()
        vc.title = "Tareas"
        present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
}
