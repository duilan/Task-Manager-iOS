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
}

struct Task: Hashable {
    let id = UUID().uuidString.lowercased()
    let title: String
}
