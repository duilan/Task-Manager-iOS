//
//  ProjectListViewModel.swift
//  Task Manager
//
//  Created by Duilan on 01/12/22.
//

protocol ProjectListDelegate: AnyObject {
    func didDeletedProject(_ project: Project)
    func didUpdatedProjectStatus(_ project: Project)
}

class ProjectListViewModel {
    
    private let repository: ProjectRepository = ProjectRepository()
    weak var delegate: ProjectListDelegate?
    
    func delete(project: Project) {
        let result = repository.delete(project)
        switch result {
        case .success():
            delegate?.didDeletedProject(project)
        case .failure(let error):
            print(error)
        }
    }
    
    func changeStatus(of project: Project, to status: StatusProject) {
        let projectEdited = project.editStatus(to: status)
        let result = repository.update(projectEdited)
        switch result {
        case .success():
            delegate?.didUpdatedProjectStatus(projectEdited)
        case .failure(let error):
            print(error)
        }
    }
    
}
