//
//  CreateProjectVM.swift
//  Task Manager
//
//  Created by Duilan on 27/10/22.
//

import Foundation

enum createProjectValidationError: String, Error {
    case requiredTitle = "Agrega un titulo"
    case requiredSubtitle = "Agrega un subtitulo"
    case startShouldBeLessThatEndDate = "La fecha de inicio debe ser menor a la de termino"
    case saveFail = "Ocurrio un error al guardar"
}
protocol CreateProjectVMDelgate: AnyObject  {
    func saveCompleted()
    func validationError(error: createProjectValidationError)
}

class CreateProjectVM {
    
    var screenTitle = "Nuevo Proyecto"
    var title: (title: String, placeHolder: String, value: String)
    var subtitle: (title: String, placeHolder: String, value: String)
    var desc: (title: String, placeHolder: String, value: String)
    var startDate: (title: String, value: Date)
    var endDate: (title: String, value: Date)
    var color: (title: String, value: Int)
    
    private let today = Date()
    private let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    
    private let respository: ProjectRepository = ProjectRepository()
    weak var delegate: CreateProjectVMDelgate?
    
    init() {
        title = (title: "Titulo", placeHolder: "Titulo del proyecto", value: "")
        subtitle = (title: "Subtitulo", placeHolder: "Subtitulo o alias", value: "")
        desc = (title: "Descripción", placeHolder: "Descripción acerca del proyecto", value: "")
        startDate = (title: "Fecha Inicio", value: today)
        endDate = (title: "Fecha Termino", value: tomorrow)
        color = (title: "Color", value: 0)
    }
    
    func isValidInfo() -> Bool {
        if title.value.isEmpty {
            delegate?.validationError(error: .requiredTitle)
            return false
        }
        if subtitle.value.isEmpty {
            delegate?.validationError(error: .requiredSubtitle)
            return false
        }
        
        let hoursDiffBetweenDates = Calendar.current.dateComponents([.hour], from: startDate.value, to: endDate.value).hour!
        
        if hoursDiffBetweenDates < 1 {
            delegate?.validationError(error: .startShouldBeLessThatEndDate)
            return false
        }
        
        return true
        
    }
    
    func createProject() {
        if isValidInfo() {
            let newProject = Project(id: UUID(), title: title.value, alias: subtitle.value, desc: desc.value, startDate: startDate.value, endDate: endDate.value, color: color.value, status: .inProgress, tasks: [], createAt: Date())
            
            let result = respository.create(newProject)
            switch result {
            case .success():
                delegate?.saveCompleted()
            case .failure( let error):
                print(error)
                delegate?.validationError(error: .saveFail)
            }
        }
    }
    
}
