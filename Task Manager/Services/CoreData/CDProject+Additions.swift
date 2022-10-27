//
//  CDProject+Additions.swift
//  Task Manager
//
//  Created by Duilan on 26/10/22.
//

import Foundation

extension CDProject: ModelConvertible {
    
    func toDomainModel() -> Project {        
        let tasksOfProject = tasks?.allObjects as? [CDTask] ?? []
        let domainTasks: [Task] = tasksOfProject.compactMap({ $0.toDomainModel() })
        
        return Project(
            id: id,
            title: title,
            alias: alias,
            desc: desc,
            startDate: startDate,
            endDate: endDate,
            color: Int(color),
            status: StatusProject(rawValue: status)!,
            tasks: domainTasks,
            createAt: createAt)
    }
}
