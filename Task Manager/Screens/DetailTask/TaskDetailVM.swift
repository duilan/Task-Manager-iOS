//
//  TaskDetailVM.swift
//  Task Manager
//
//  Created by Duilan on 02/11/22.
//

import Foundation

protocol TaskDetailDelegate: AnyObject {
    func taskDetailUpdated()
    func validationError(error : Task.TaskError)
}

class TaskDetailVM {
    
    var taskName: (title: String, placeHolder: String, value: String)
    var taskNotes: (title: String, value: String)
    var taskPriority: (title: String, value: Priority)
    
    private let task: Task
    private let repository: TaskRepository = TaskRepository()
    
    weak var delegate: TaskDetailDelegate?
    
    init(of task: Task) {
        self.task = task
        taskName = (title: "Nombre", placeHolder: "Nombre de la tarea", value: task.title)
        taskNotes = (title: "Notas", value: task.notes ?? "")
        taskPriority = (title: "Priority", value: task.priority)
    }
    
    func updateDetailTask() {
        
        // remove whitespaces
        taskName.value = taskName.value.trimmingCharacters(in: .whitespacesAndNewlines)
        taskNotes.value = taskNotes.value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            let taskToUpdate = try task.edit(title: taskName.value, notes: taskNotes.value, priority: taskPriority.value)
            
            let result = repository.update(taskToUpdate)
            
            switch result {
            case .success():
                delegate?.taskDetailUpdated()
            case .failure(let error):
                print(error.localizedDescription)
            }
        } catch {
            delegate?.validationError(error: error as! Task.TaskError)
        }
    }
    
}
