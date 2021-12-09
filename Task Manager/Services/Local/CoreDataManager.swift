//
//  CoreDataManager.swift
//  Task Manager
//
//  Created by Duilan on 27/10/21.
//

import CoreData

final class CoreDataManager {
    
    // singleton access
    public static var shared = CoreDataManager()
    
    private let dataBaseName = "TaskManager"
    private let container: NSPersistentContainer!
    
    private init() {
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
    
    func fetchProject(id: String, completion: @escaping(Project)-> Void) {
        let context = container.viewContext
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            if let project = try context.fetch(request).first {
                completion(project)
            } else {
                print("peoject with id:\(id) doesnt exist")
            }
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
    
    func addTask(title: String, notes: String?, to project: Project, completion: @escaping() -> Void) {
        
        let context = container.viewContext
        // verificamos que el proyecto exista en el MOC
        guard let existingProject = context.object(with: project.objectID) as? Project else { return }
        
        let task = Task(context: context)
        task.id = UUID().uuidString.lowercased()
        task.createAt = Date()
        task.title = title
        task.notes = notes
        task.isDone = false
        task.project = existingProject // relation to parent
        // save
        do {
            try context.save()
            completion()
            print("Se agrego nueva tarea")
        } catch {
            print(error)
        }
    }
    
    func fetchTasksOf(_ project: Project, completion: @escaping([Task]) -> Void) {
        
        let context = container.viewContext
        // verificamos que el proyecto exista en el MOC
        guard let existingProject = context.object(with: project.objectID) as? Project else { return }
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let predicate  = NSPredicate(format: "project == %@", existingProject)
        let sort = NSSortDescriptor(key: #keyPath(Task.createAt), ascending: false)
        
        request.predicate = predicate
        request.sortDescriptors = [sort]
        
        do {
            let tasks = try context.fetch(request)
            completion(tasks)
        } catch {
            print(error)
        }
    }
    
    func updateTask(with task: Task, completion: @escaping() -> Void) {
        
        guard let context = task.managedObjectContext else { return }
        
        do {
            try context.save()
            completion()
        } catch {
            print(error)
        }
    }
    
    func delete(_ object: NSManagedObject, completion: @escaping() -> Void) {
        let context = container.viewContext
        context.delete(object)
        do {
            try context.save()
            completion()
        } catch {
            print(error)
        }
    }
        
}
