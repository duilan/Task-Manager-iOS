//
//  DummyData.swift
//  Task Manager
//
//  Created by Duilan on 16/10/21.
//

import Foundation

struct DummyData {
    
    static let shared = DummyData()
    
    private init() { }
    
    let projects = [
        Project(alias: "alias0", title: "titulo0", tasks: [Task(title: "Titulo de la tarea")], status: .completed),
        Project(alias: "alias1", title: "titulo1", tasks: [Task(title: "Titulo de la tarea")], status: .inProgress),
        Project(alias: "alias2", title: "titulo2", tasks: [Task(title: "Titulo de la tarea")], status: .inProgress),
        Project(alias: "alias3", title: "titulo3", tasks: [Task(title: "Titulo de la tarea")], status: .completed),
        Project(alias: "alias4", title: "titulo4", tasks: [Task(title: "Titulo de la tarea")], status: .inProgress),
        Project(alias: "alias5", title: "titulo5", tasks: [Task(title: "Titulo de la tarea")], status: .inProgress),
        Project(alias: "alias6", title: "titulo6", tasks: [Task(title: "Titulo de la tarea")], status: .completed),
        Project(alias: "alias7", title: "titulo7", tasks: [Task(title: "Titulo de la tarea")], status: .inProgress),
        Project(alias: "alias8", title: "titulo8", tasks: [Task(title: "Titulo de la tarea")], status: .completed),
        Project(alias: "alias9", title: "titulo9", tasks: [Task(title: "Titulo de la tarea")], status: .completed),
    ]
    
}
