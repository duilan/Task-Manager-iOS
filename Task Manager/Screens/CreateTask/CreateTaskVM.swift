//
//  CreateTaskVM.swift
//  Task Manager
//
//  Created by Duilan on 01/11/22.
//

import Foundation

protocol CreateTaskVMDelegate: AnyObject {
    func saveCompleted()
    func validationError(error: Task.TaskError )
}

class CreateTaskVM {
    
    var screenTitle = "Nueva Tarea"
    var taskName: (title: String, placeHolder: String, value: String)
    var taskNotes: (title: String, value: String)
    var taskPriority: (title: String, value: Priority)
    var colorProject: ProjectColors
    let project: Project
    
    private let repository: TaskRepository = TaskRepository()
    weak var delegate: CreateTaskVMDelegate?
    
    init(project: Project) {
        self.project = project
        taskName = (title: "Nombre", placeHolder: "Nombre de la tarea", value: "")
        taskNotes = (title: "Notas", value: "")
        taskPriority = (title: "Prioridad", value: .normal)
        colorProject = ProjectColors(rawValue: project.color)!
    }
    
    
    
    func createTask() {
        // trim whitespaces
        taskName.value = taskName.value.trimmingCharacters(in: .whitespacesAndNewlines)
        taskNotes.value = taskNotes.value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            let newTask = try Task.create(title: taskName.value, notes: taskNotes.value, priority: taskPriority.value, projectID: project.id)
            
            let result = repository.create(newTask)
            switch result {
            case .success():
                delegate?.saveCompleted()
            case .failure(let error):
                print(error.localizedDescription)
            }
        } catch {
            delegate?.validationError(error: error as! Task.TaskError)
        }
    }    
    
}
