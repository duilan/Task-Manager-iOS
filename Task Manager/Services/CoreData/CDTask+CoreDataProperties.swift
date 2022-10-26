//
//  CDTask+CoreDataProperties.swift
//  Task Manager
//
//  Created by Duilan on 27/08/22.
//
//

import Foundation
import CoreData


extension CDTask {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTask> {
        return NSFetchRequest<CDTask>(entityName: "CDTask")
    }
    
    @NSManaged public var createAt: Date
    @NSManaged public var doneAt: Date?
    @NSManaged public var id: UUID
    @NSManaged public var isDone: Bool
    @NSManaged public var notes: String?
    @NSManaged public var priority: Int64
    @NSManaged public var title: String
    @NSManaged public var project: CDProject
    
}

extension CDTask : Identifiable {
    
}
