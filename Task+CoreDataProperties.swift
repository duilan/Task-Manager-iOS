//
//  Task+CoreDataProperties.swift
//  Task Manager
//
//  Created by Duilan on 27/08/22.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var createAt: Date
    @NSManaged public var doneAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var isDone: Bool
    @NSManaged public var notes: String?
    @NSManaged public var priority: Int64
    @NSManaged public var title: String
    @NSManaged public var project: Project

}

extension Task : Identifiable {

}
