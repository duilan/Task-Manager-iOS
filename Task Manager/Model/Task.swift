//
//  Task.swift
//  Task Manager
//
//  Created by Duilan on 25/10/22.
//

import Foundation

struct Task {
    let id: UUID
    let title: String
    let notes: String?
    let priority: Priority
    let isDone: Bool
    let doneAt: Date?
    let createAt: Date
    let projectID: UUID
    
    enum TaskError: Equatable ,Error {
        case emptyTitleisNotAllowed
    }
}

extension Task: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Task {
    
    static func create(title: String, notes: String, priority: Priority, projectID: UUID) throws -> Task {
        
        if title.isEmpty { throw TaskError.emptyTitleisNotAllowed }
        
        return Task(id: UUID(), title: title, notes: notes, priority: priority, isDone: false, doneAt: nil, createAt: Date(), projectID: projectID)
    }
    
    func edit(title: String, notes: String, priority: Priority) throws -> Task {
        
        if title.isEmpty { throw TaskError.emptyTitleisNotAllowed }
        
        return Task(id: self.id, title: title, notes: notes, priority: priority, isDone: self.isDone, doneAt: self.doneAt, createAt: self.createAt, projectID: self.projectID)
    }
    
    func editDoneState(to value: Bool) -> Task {
        return Task(id: self.id, title: title, notes: notes, priority: priority, isDone: value, doneAt: Date(), createAt: self.createAt, projectID: self.projectID)
    }
    
}

enum Priority: Int, CaseIterable {
    case normal = 0
    case moderada = 1
    case importante = 2
    
    var value: Int {
        return self.rawValue
    }
    
    var text: String {
        switch self {
        case .normal:
            return "Normal"
        case .moderada:
            return "Moderada"
        case .importante:
            return "Importante"
        }
    }
}
