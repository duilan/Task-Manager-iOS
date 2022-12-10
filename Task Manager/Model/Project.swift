//
//  Project.swift
//  Task Manager
//
//  Created by Duilan on 16/10/21.
//

import Foundation
import UIKit

struct Project {
    let id: UUID
    let title: String
    let alias: String
    let desc: String?
    let startDate: Date
    let endDate: Date
    let color: Int
    let status: StatusProject
    let tasks: [Task]
    let createAt: Date
    
    enum ProjectError: Equatable, Error {
        case emptyTitleisNotAllowed
        case emptySubtitleisNotAllowed
        case startDateShouldBeLessThatEndDate
    }
}

extension Project: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Project {
    // MARK: - Create project case 
    static func create(title: String, alias: String, desc: String, startDate: Date, endDate: Date, color: Int) throws  -> Project {
        
        let hoursDiffBetweenDates = Calendar.current.dateComponents([.hour], from: startDate, to: endDate).hour!
        
        if title.isEmpty { throw ProjectError.emptyTitleisNotAllowed }
        if alias.isEmpty { throw ProjectError.emptySubtitleisNotAllowed }
        if hoursDiffBetweenDates < 0 { throw ProjectError.startDateShouldBeLessThatEndDate }
        
        return Project(id: UUID(), title: title, alias: alias, desc: desc, startDate: startDate, endDate: endDate, color: color, status: .inProgress , tasks: [], createAt: Date())
    }
    
    func editStatus(to value: StatusProject) -> Project {
        return Project(id: id, title: title, alias: alias, desc: desc, startDate: startDate, endDate: endDate, color: color, status: value, tasks: tasks, createAt: createAt)
    }
}

enum StatusProject: String, CaseIterable {
    case inProgress = "En Progreso"
    case completed = "Completado"
    
    var value: String {
        return rawValue
    }
    
    var icon : String {
        switch self {
        case .inProgress:
            return "rectangle.stack"
        case .completed:
            return "sparkles.rectangle.stack"
        }
    }
}

enum ProjectColors: Int, CaseIterable {
    case blue = 0
    case green = 1
    case orange = 2
    case purple = 3
    case red = 4
    case brown = 5
    case indigo = 6
    case yellow = 7
    case cyan = 8
    
    var value: UIColor {
        switch self {
        case .blue:
            return UIColor.systemBlue
        case .green:
            return UIColor.systemGreen
        case .orange:
            return UIColor.systemOrange
        case .purple:
            return UIColor.systemPurple
        case .red:
            return UIColor.systemRed
        case .brown:
            return UIColor.brown
        case .indigo:
            return UIColor.systemIndigo
        case .yellow:
            return UIColor.yellow.darker()
        case .cyan:
            return UIColor.systemTeal.darker()
        }
    }
}
