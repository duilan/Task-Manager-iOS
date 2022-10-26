//
//  Task.swift
//  Task Manager
//
//  Created by Duilan on 25/10/22.
//

import Foundation

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
