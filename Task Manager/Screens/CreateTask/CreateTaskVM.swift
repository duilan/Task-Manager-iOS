//
//  CreateTaskVM.swift
//  Task Manager
//
//  Created by Duilan on 01/11/22.
//

import Foundation

enum CreateTaskValidationError: String, Error {
    case requiredName = "Agrega nombre a la tarea"
    case saveFail = "Ocurrio un error al guardar"
}

protocol CreateTaskVMDelegate: AnyObject {
    func saveCompleted()
    func validationError(error: CreateTaskValidationError )
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
    
    func isValidTask() -> Bool {
        // trim whitespaces
        taskName.value = taskName.value.trimmingCharacters(in: .whitespacesAndNewlines)
        taskNotes.value = taskNotes.value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if taskName.value.isEmpty {
            delegate?.validationError(error: .requiredName)
            return false
        }
        
        return true
    }
    
    func createTask() {
        if isValidTask() {
            let newTask = Task(id: UUID(), title: taskName.value, notes: taskNotes.value, priority: taskPriority.value, isDone: false, doneAt: nil, createAt: Date(), projectID: project.id)
            
            let result = repository.create(newTask)
            switch result {
            case .success():
                delegate?.saveCompleted()
            case .failure(let error):
                print(error.localizedDescription)
                delegate?.validationError(error: .saveFail)
            }
        }
    }    
    
}
