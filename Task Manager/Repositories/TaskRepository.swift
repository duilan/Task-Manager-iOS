//
//  TaskRepository.swift
//  Task Manager
//
//  Created by Duilan on 25/10/22.
//

import Foundation

class TaskRepository: TaskRepositoryProtocol {
    
    let store = CoreDataManager.shared
    
    func getAllBy(_ projectID: UUID) -> Result<[Task], RepositoryError> {
        do {
            // se podria mejorar pasando un predicate y un sort al fetch generico
            // Ej. let tasks = try store.fetch(entity: CDTask, predicate, sortedBy)
            let project =  try store.fetchById(entity: CDProject.self, id: projectID)
            let tasks = project?.toDomainModel().tasks ?? []
            let tasksSorted = tasks.sorted { $0.createAt > $1.createAt }
            return .success(tasksSorted)
        } catch {
            print(error)
            return .failure(.failError)
        }
    }
    
    func getByID(_ id: UUID) -> Result<Task?, RepositoryError> {
        do {
            let task = try store.fetchById(entity: CDTask.self, id: id)
            return .success(task?.toDomainModel())
        } catch {
            print(error)
            return .failure(.failError)
        }
    }
    
    func create(_ item: Task) -> Result<Void, RepositoryError> {
        guard let projectRelationship = try? store.fetchById(entity: CDProject.self, id: item.projectID) else { return .failure(.failError) }
        
        let newTask = CDTask(context: store.context)
        newTask.id = item.id
        newTask.createAt = item.createAt
        newTask.title = item.title
        newTask.notes = item.notes
        newTask.priority = Int64(item.priority.value)
        newTask.isDone = item.isDone
        newTask.project = projectRelationship
        
        do {
            try store.saveContext()
            return .success(())
        } catch  {
            print(error)
            return .failure(.failError)
        }
    }
    
    func update(_ item: Task) -> Result<Void, RepositoryError> {
        guard let task = try? store.fetchById(entity: CDTask.self, id: item.id) else {
            return .failure(.failError) }
        
        task.title = item.title
        task.notes = item.notes
        task.priority = Int64(item.priority.value)
        task.isDone = item.isDone
        task.doneAt = item.doneAt
        
        do {
            try store.saveContext()
            return .success(())
        } catch {
            print(error)
            return .failure(.failError)
        }
    }
    
    func delete(_ item: Task) -> Result<Void, RepositoryError> {
        guard let task = try? store.fetchById(entity: CDTask.self, id: item.id) else {
            return .failure(.failError)
        }
        
        do {
            try store.delete(task)
            return .success(())
        } catch {
            print(error)
            return .failure(.failError)
        }
    }
    
}
