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
        Project(alias: "alias", title: "titulo", tasks: [Task(title: "Titulo de la tarea")]),
        Project(alias: "alias", title: "titulo", tasks: [Task(title: "Titulo de la tarea")]),
        Project(alias: "alias", title: "titulo", tasks: [Task(title: "Titulo de la tarea")]),
        Project(alias: "alias", title: "titulo", tasks: [Task(title: "Titulo de la tarea")]),
        Project(alias: "alias", title: "titulo", tasks: [Task(title: "Titulo de la tarea")]),
        Project(alias: "alias", title: "titulo", tasks: [Task(title: "Titulo de la tarea")]),
        Project(alias: "alias", title: "titulo", tasks: [Task(title: "Titulo de la tarea")]),
        Project(alias: "alias", title: "titulo", tasks: [Task(title: "Titulo de la tarea")]),
        Project(alias: "alias", title: "titulo", tasks: [Task(title: "Titulo de la tarea")])
    ]
}
