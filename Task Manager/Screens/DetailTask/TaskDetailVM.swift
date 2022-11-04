//
//  TaskDetailVM.swift
//  Task Manager
//
//  Created by Duilan on 02/11/22.
//

import Foundation

enum DetailTaskValidationError: String, Error {
    case requiredName = "Agrega nombre a la tarea"
    case updateFail = "Ocurrio un error al guardar cambios"
}

protocol TaskDetailDelegate: AnyObject {
    func taskDetailUpdated()
    func taskWithOutChanges()
    func validationError(error : DetailTaskValidationError)
}

class TaskDetailVM {
    
    var taskName: (title: String, placeHolder: String, value: String)
    var taskNotes: (title: String, value: String?)
    var taskPriority: (title: String, value: Priority)
    
    private let task: Task
    private let repository: TaskRepository = TaskRepository()
    
    weak var delegate: TaskDetailDelegate?
    
    init(of task: Task) {
        self.task = task
        taskName = (title: "Nombre", placeHolder: "Nombre de la tarea", value: task.title)
        taskNotes = (title: "Notas", value: task.notes)
        taskPriority = (title: "Priority", value: task.priority)
    }
    
    func updateDetailTask() {
        guard isValidTask() else { return }
        guard hasNewChanges() else {
            delegate?.taskWithOutChanges()
            return
        }
        
        let taskToUpdate = Task(id: task.id, title: taskName.value, notes: taskNotes.value, priority: taskPriority.value, isDone: task.isDone, doneAt: task.doneAt, createAt: task.createAt, projectID: task.projectID)
        
        let result = repository.update(taskToUpdate)
        
        switch result {
        case .success():
            delegate?.taskDetailUpdated()
        case .failure(let error):
            print(error.localizedDescription)
            delegate?.validationError(error: .updateFail)
        }
    }
    
    func hasNewChanges() -> Bool {
        if task.title != taskName.value || task.notes != taskNotes.value || task.priority != taskPriority.value {
            return true
        }
        return false
    }
    
    func isValidTask() -> Bool{
        // remove whitespaces
        taskName.value = taskName.value.trimmingCharacters(in: .whitespacesAndNewlines)
        taskNotes.value = taskNotes.value?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if taskName.value.isEmpty {
            delegate?.validationError(error: .requiredName)
            return false
        }
        
        return true
    }
    
}
