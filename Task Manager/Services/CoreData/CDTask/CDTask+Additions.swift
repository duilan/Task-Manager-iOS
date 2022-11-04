//
//  CDTask+Additions.swift
//  Task Manager
//
//  Created by Duilan on 26/10/22.
//

import Foundation

extension CDTask: ModelConvertible {
    
    func toDomainModel() -> Task {
        return Task(
            id: id,
            title: title,
            notes: notes,
            priority: Priority.init(rawValue: Int(priority))!,
            isDone: isDone,
            doneAt: doneAt,
            createAt: createAt,
            projectID: project.id)
    }
}
