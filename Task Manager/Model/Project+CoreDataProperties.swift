//
//  Project+CoreDataProperties.swift
//  Task Manager
//
//  Created by Duilan on 27/08/22.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
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
extension Project {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension Project : Identifiable {

}
