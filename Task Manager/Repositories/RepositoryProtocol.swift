//
//  RepositoryProtocol.swift
//  Task Manager
//
//  Created by Duilan on 24/10/22.
//

import Foundation

enum RepositoryError: Error {
    case failError
}

protocol RepositoryProtocol {
    associatedtype Entity
    func getAll() -> Result<[Entity],RepositoryError>
    func getByID(_ id: UUID) -> Result<Entity?,RepositoryError>
    func create(_ item: Entity) -> Result<Void,RepositoryError>
    func update(_ item: Entity) -> Result<Void,RepositoryError>
    func delete(_ item: Entity) -> Result<Void,RepositoryError>
}
