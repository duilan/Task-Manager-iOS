//
//  Project.swift
//  Task Manager
//
//  Created by Duilan on 16/10/21.
//

import Foundation
import UIKit

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
