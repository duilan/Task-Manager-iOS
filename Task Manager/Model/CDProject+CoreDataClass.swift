//
//  CDProject+CoreDataClass.swift
//  Task Manager
//
//  Created by Duilan on 27/08/22.
//
//

import Foundation
import CoreData

@objc(CDProject)
public class CDProject: NSManagedObject {
    
    var statusDescription: StatusProject {
        get {
            return StatusProject(rawValue: self.status)!
        }
        set {
            return self.status = newValue.rawValue
        }
    }
    
    var totalTasks: Int {
        return tasks?.count ?? 0
    }
}
