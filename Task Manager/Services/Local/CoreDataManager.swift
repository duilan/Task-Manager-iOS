//
//  CoreDataManager.swift
//  Task Manager
//
//  Created by Duilan on 27/10/21.
//

import CoreData

final class CoreDataManager {
    
    // Singleton
    public static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let databaseName = "TaskManager"
        let container = NSPersistentContainer(name: databaseName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unable to load persistent stores: \(error) , \(error.userInfo)")
            }
            print("CoreData: \(databaseName) Loaded!")
        }
        return container
    }()
    
    private let context: NSManagedObjectContext
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    func fetchAllProjects( completion: @escaping ([Project]) -> Void) {
        let request : NSFetchRequest<Project> = Project.fetchRequest()
        // sort result by createAt date
        let sort = NSSortDescriptor(keyPath: \Project.createAt, ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            let result = try context.fetch(request)
            completion(result)
        } catch {
            print(error)
        }
    }
    
    func fetchProject(id: UUID, completion: @escaping(Project?)-> Void) {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let project = try context.fetch(request).first
            completion(project)
        } catch {
            print(error)
        }
    }
    
    func createProject(alias: String, title: String , desc: String? = nil, startDate: Date, endDate: Date, color: Int, completion: @escaping() -> Void ) {
        
        let project = Project(context: context)
        // setup project obj
        project.id = UUID()
        project.alias = alias
        project.title = title
        project.desc = desc
        project.statusDescription = .inProgress // this will set raw value at status
        project.createAt = Date()
        project.startDate = startDate
        project.endDate = endDate
        project.color = Int64(color)
        // save
        do {
            try context.save()
            print("Se creo el proyecto: \(project.title)")
            completion()
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
    
    func addTask(title: String, notes: String?, priority: Int, to project: Project, completion: @escaping() -> Void) {
        // verificamos que el proyecto exista en el MOC
        guard let existingProject = context.object(with: project.objectID) as? Project else { return }
        
        let task = Task(context: context)
        task.id = UUID()
        task.createAt = Date()
        task.title = title
        task.notes = notes
        task.priority = Int64(priority)
        task.isDone = false
        task.project = existingProject // relation to parent
        // save
        do {
            try context.save()
            completion()
            print("Se creo tarea \(task.title) en el proyecto \(existingProject.title)")
        } catch {
            print(error)
        }
    }
    
    func fetchTasksOf(_ project: Project, completion: @escaping([Task]) -> Void) {
        // verificamos que el proyecto exista en el MOC
        guard let existingProject = context.object(with: project.objectID) as? Project else { return }
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let predicate  = NSPredicate(format: "project == %@", existingProject)
        let sort = NSSortDescriptor(keyPath: \Task.createAt, ascending: false)
        
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
    
    func sqliteFilePath() {
        print("SQLite File Path:  \(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!)")
    }
    
}
