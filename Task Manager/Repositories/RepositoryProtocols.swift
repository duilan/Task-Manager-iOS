//
//  RepositoryProtocols.swift
//  Task Manager
//
//  Created by Duilan on 24/10/22.
//

import Foundation

// Cada protocol de repositorio y error
// deberia estar en archivo separado
// en este caso lo pondre todo aqui

enum RepositoryError: Error {
    case failError
}

protocol ProjectRepositoryProtocol {
    func getAll() -> Result<[Project],RepositoryError>
    func getByID(_ id: UUID) -> Result<Project?,RepositoryError>
    func create(_ item: Project) -> Result<Void,RepositoryError>
    func update(_ item: Project) -> Result<Void,RepositoryError>
    func delete(_ item: Project) -> Result<Void,RepositoryError>
}

protocol TaskRepositoryProtocol {
    func getAllBy(_ projectID: UUID) -> Result<[Task],RepositoryError>
    func getByID(_ id: UUID) -> Result<Task?,RepositoryError>
    func create(_ item: Task) -> Result<Void,RepositoryError>
    func update(_ item: Task) -> Result<Void,RepositoryError>
    func delete(_ item: Task) -> Result<Void,RepositoryError>
}
