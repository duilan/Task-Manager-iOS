//
//  Project.swift
//  Task Manager
//
//  Created by Duilan on 16/10/21.
//

import Foundation

struct Project: Hashable {
    let id = UUID().uuidString.lowercased()
    let alias: String
    let title: String
    let tasks: [Task]
    let status: StatusProject
    let createAt = Date()
}

struct Task: Hashable {
    let id = UUID().uuidString.lowercased()
    let title: String
}

enum StatusProject: String, CaseIterable {
    case inProgress = "En Progreso"
    case completed = "Completado"
}
