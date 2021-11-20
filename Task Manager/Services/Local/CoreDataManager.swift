//
//  CoreDataManager.swift
//  Task Manager
//
//  Created by Duilan on 27/10/21.
//

import CoreData

final class CoreDataManager {
    
    private let dataBaseName = "TaskManager"
    private let container: NSPersistentContainer!
    
    init() {
        container = NSPersistentContainer(name: dataBaseName)
        configureDatabase()
    }
    
    private func configureDatabase() {
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unable to load persistent stores: \(error) , \(error.userInfo)")
            }
            print("CoreData: \(self.dataBaseName) Loaded!")
            // Ruta del archivo sql
            //print("Sqlite File: \(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!)")
        }
    }
    
    func fetchAllProjects( completion: @escaping ([Project]) -> Void) {
        
        let context = container.viewContext
        let request : NSFetchRequest<Project> = Project.fetchRequest()
        // sort result by createAt date
        let sort = NSSortDescriptor(key: #keyPath(Project.createAt), ascending: false)
        request.sortDescriptors = [sort]
        // fetch
        do {
            let result = try context.fetch(request)
            completion(result)
        } catch {
            print(error)
        }
    }
    
    func createProject(alias: String, title: String , desc: String? = nil, startDate: Date, endDate: Date?, completion: @escaping() -> Void ) {
        
        let context = container.viewContext
        let project = Project(context: context)
        // setup project obj
        project.id = UUID().uuidString.lowercased()
        project.alias = alias
        project.title = title
        project.desc = desc
        project.status = StatusProject.inProgress.rawValue
        project.createAt = Date()
        project.startDate = startDate
        project.endDate = endDate
        // save
        do {
            try context.save()
            print("Se guardo")
            completion()
        } catch {
            print(error)
        }
    }
    
    func addTask(title: String, desc: String?, to project: Project, completion: @escaping() -> Void) {
        // implementar mejor el uso de contextos para este caso!!
        guard let existContext = project.managedObjectContext else { return }
        
        let task = Task(context: existContext)
        task.id = UUID().uuidString.lowercased()
        task.createAt = Date()
        task.title = title
        task.status = "Pendiente"
        project.addToTasks(task)
        
        do {
            try existContext.save()
            completion()
            print("Se agrego nueva tarea")
        } catch {
            print(error)
        }
    }
    
}
