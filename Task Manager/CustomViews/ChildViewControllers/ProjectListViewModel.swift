//
//  ProjectListViewModel.swift
//  Task Manager
//
//  Created by Duilan on 01/12/22.
//

protocol ProjectListDelegate: AnyObject {
    func didDeletedProject(_ project: Project)
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
    
}
