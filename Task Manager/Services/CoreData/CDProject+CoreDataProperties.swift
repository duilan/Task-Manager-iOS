//
//  CDProject+CoreDataProperties.swift
//  Task Manager
//
//  Created by Duilan on 27/08/22.
//
//

import Foundation
import CoreData


extension CDProject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDProject> {
        return NSFetchRequest<CDProject>(entityName: "CDProject")
    }
    
    @NSManaged public var alias: String
    @NSManaged public var color: Int64
    @NSManaged public var createAt: Date
    @NSManaged public var desc: String?
    @NSManaged public var endDate: Date
    @NSManaged public var id: UUID
    @NSManaged public var startDate: Date
    @NSManaged public var status: String
    @NSManaged public var title: String
    @NSManaged public var tasks: NSSet?
    
}

// MARK: Generated accessors for tasks
extension CDProject {
    
    @objc(addCDTasksObject:)
    @NSManaged public func addToTasks(_ value: CDTask)
    
    @objc(removeCDTasksObject:)
    @NSManaged public func removeFromTasks(_ value: CDTask)
    
    @objc(addCDTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)
    
    @objc(removeCDTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)
    
}

extension CDProject : Identifiable {
    
}
