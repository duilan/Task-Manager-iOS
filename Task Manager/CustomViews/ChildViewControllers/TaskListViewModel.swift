//
//  TaskListViewModel.swift
//  Task Manager
//
//  Created by Duilan on 04/11/22.
//

import Foundation

protocol TaskListViewModelDelegate: AnyObject {
    func didLoadData()
}

class TaskListViewModel {
    
    private let repository: TaskRepositoryProtocol = TaskRepository()
    var projectID : UUID?
    var taskList: [TaskList] = []
    weak var delegate: TaskListViewModelDelegate?
    
    enum Section: String, CaseIterable {
        case pending = "Pendientes"
        case completed = "Completadas"
    }
    
    struct TaskList {
        var section: Section
        var tasks: [Task]
    }
    
    func loadTasks() {
        guard let projectID = projectID else {
            taskList = []
            delegate?.didLoadData()
            return
            
        }
        let result = repository.getAllBy(projectID)
        switch result {
        case .success(let data):
            taskList = createTaskList(data)
            delegate?.didLoadData()
        case .failure(let error):
            print(error)
        }
    }
    
    func delete(task:Task) {
        let result = repository.delete(task)
        switch result {
        case .success():
            loadTasks()
        case .failure(let error):
            print(error)
        }
    }
    
    func toggleDoneStatus(of task: Task) {
        let toggleValue = !task.isDone
        let taskEdited = task.editDoneState(to: toggleValue)
        let result =  repository.update(taskEdited)
        switch result {
        case .success():
            loadTasks()
        case .failure(let error):
            print(error)
        }
    }
    
    private func createTaskList(_ data: [Task]) -> [TaskList] {
        let pendingTasks = data.filter({ $0.isDone == false })
        let completedTasks = data.filter({ $0.isDone == true })
        
        var list: [TaskList] = []
        if pendingTasks.count > 0 {
            list.append(TaskList(section: .pending, tasks: pendingTasks))
        }
        if completedTasks.count > 0 {
            list.append(TaskList(section: .completed, tasks: completedTasks))
        }
        
        return list
        
        //            Funciona de manera generica, pero es importante el sorted; sino
        //            genera problemas con diffabletables
        //            let grouped = Dictionary(grouping: data) {
        //                return  $0.isDone == false ? Section.pending : Section.completed
        //            }
        //            let groupedSorted = grouped.sorted { $0.key.rawValue > $1.key.rawValue }
        //            list = groupedSorted.map { TaskList(section: $0.key, tasks: $0.value) }
    }
    
}
