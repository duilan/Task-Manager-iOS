//
//  ProjectRepository.swift
//  Task Manager
//
//  Created by Duilan on 24/10/22.
//

import Foundation

class ProjectRepository: ProjectRepositoryProtocol {
    
    let store = CoreDataManager.shared
    
    func getAll() -> Result<[Project], RepositoryError> {
        do {
            let projects = try store.fetch(entity: CDProject.self)
            return .success(projects.map({ $0.toDomainModel() }))
        } catch {
            print(error)
            return .failure(.failError)
        }
    }
    
    func getByID(_ id: UUID) -> Result<Project?, RepositoryError> {
        do {
            let project =  try store.fetchById(entity: CDProject.self, id: id)
            return .success(project?.toDomainModel())
        } catch {
            return .failure(.failError)
        }
    }
    
    func create(_ item: Project) -> Result<Void, RepositoryError> {
        
        let newProject = CDProject(context: store.context)
        newProject.id = item.id
        newProject.title = item.title
        newProject.alias = item.alias
        newProject.desc = item.desc
        newProject.startDate = item.startDate
        newProject.endDate = item.endDate
        newProject.status = item.status.value
        newProject.color = Int64(item.color)
        newProject.createAt = item.createAt
        //newProject.tasks
        
        do {
            try store.saveContext()
            return .success(())
        } catch  {
            print(error)
            return .failure(.failError)
        }
    }
    
    func update(_ item: Project) -> Result<Void, RepositoryError> {
        guard let project = try? store.fetchById(entity: CDProject.self, id: item.id) else {
            return .failure(.failError)
        }
        project.status = item.status.value
        do {
            try store.context.save()
            return .success(())
        } catch {
            print(error)
            return .failure(.failError)
        }
    }
    
    func delete(_ item: Project) -> Result<Void, RepositoryError> {
        guard let project = try? store.fetchById(entity: CDProject.self, id: item.id) else {
            return .failure(.failError)
        }
        
        do {
            try store.delete(project)
            return .success(())
        } catch {
            print(error)
            return .failure(.failError)
        }
    }
    
}
