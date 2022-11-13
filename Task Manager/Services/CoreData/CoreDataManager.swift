//
//  CoreDataManager.swift
//  Task Manager
//
//  Created by Duilan on 27/10/21.
//

import CoreData

final class CoreDataManager {
    
    enum StorageType {
        case persistent, inMemory
    }
    // Singleton
    static let shared = CoreDataManager(storageType: .persistent)
    
    let context: NSManagedObjectContext
    
    private init(storageType: StorageType = .persistent) {
        
        let databaseName = "TaskManager"
        let persistentContainer = NSPersistentContainer(name: databaseName)
        
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            persistentContainer.persistentStoreDescriptions = [description]
        }
        
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unable to load persistent stores: \(error) , \(error.userInfo)")
            }
            print("CoreData Name: \(databaseName) Loaded!")
        }
        
        context = persistentContainer.viewContext
        
    }
    
    func sqliteFilePath() {
        print("SQLite File Path:  \(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!)")
    }
    
    func fetch<T: NSManagedObject>(entity: T.Type) throws -> [T]  {
        let request = entity.fetchRequest() as! NSFetchRequest<T>
        let result = try context.fetch(request)
        return result
    }
    
    func fetchById<T: NSManagedObject>(entity: T.Type, id: UUID) throws -> T?  {
        let request = entity.fetchRequest() as! NSFetchRequest<T>
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let item = try context.fetch(request).first
        return item
    }
    
    func delete<T: NSManagedObject>(_ item: T) throws {
        context.delete(item)
        try saveContext()
    }
    
    func saveContext() throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                fatalError("Error Coredata: \(error)")
            }
        }
    }
    
    func fetchAllProjects( completion: @escaping ([CDProject]) -> Void) {
        let request : NSFetchRequest<CDProject> = CDProject.fetchRequest()
        // sort result by createAt date
        let sort = NSSortDescriptor(keyPath: \CDProject.createAt, ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            let result = try context.fetch(request)
            completion(result)
        } catch {
            print(error)
        }
    }
    
    func update( completion: @escaping() -> Void) {
        do {
            try context.save()
            completion()
        } catch  {
            print(error)
        }
    }
    
    func fetchTasksOf(_ project: CDProject, completion: @escaping([CDTask]) -> Void) {
        // verificamos que el proyecto exista en el MOC
        guard let existingProject = context.object(with: project.objectID) as? CDProject else { return }
        
        let request: NSFetchRequest<CDTask> = CDTask.fetchRequest()
        let predicate  = NSPredicate(format: "project == %@", existingProject)
        let sort = NSSortDescriptor(keyPath: \CDTask.createAt, ascending: false)
        
        request.predicate = predicate
        request.sortDescriptors = [sort]
        
        do {
            let tasks = try context.fetch(request)
            completion(tasks)
        } catch {
            print(error)
        }
    }
    
    func updateTask(with task: CDTask, completion: @escaping() -> Void) {
        do {
            try context.save()
            completion()
            print("Tarea actualizada")
        } catch {
            print(error)
        }
    }
    
    func delete(_ object: NSManagedObject, completion: @escaping() -> Void) {
        context.delete(object)
        do {
            try context.save()
            completion()
            print("Se elimino")
        } catch {
            print(error)
        }
    }
    
}
