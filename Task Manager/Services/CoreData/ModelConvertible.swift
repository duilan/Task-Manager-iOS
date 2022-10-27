//
//  ModelConvertible.swift
//  Task Manager
//
//  Created by Duilan on 26/10/22.
//

import Foundation

protocol ModelConvertible: AnyObject {
    associatedtype DomainModelType
    func toDomainModel() -> DomainModelType
}
