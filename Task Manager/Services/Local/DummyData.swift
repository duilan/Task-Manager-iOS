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
        Project(alias: "Coffe Shop", title: "App coffe shop para iOS, Android y Web", tasks: [Task(title: "Titulo de la tarea")], status: .completed),
        Project(alias: "Portafolio", title: "Mi Portafolio Personal", tasks: [Task(title: "Titulo de la tarea")], status: .inProgress),
        Project(alias: "Random Workout App", title: "App Random Workout para iOS", tasks: [Task(title: "Titulo de la tarea")], status: .inProgress),
        Project(alias: "Esto es un alias", title: "Configuracion del servidor DELL en el piso 7", tasks: [Task(title: "Titulo de la tarea")], status: .completed),
        Project(alias: "Logo de MasterGym", title: "Diseño del Logo para MasterGym", tasks: [Task(title: "Titulo de la tarea")], status: .inProgress),
        Project(alias: "Analisis de Sistemas", title: "Tarea Analisis", tasks: [Task(title: "Titulo de la tarea")], status: .inProgress),
        Project(alias: "Tesis", title: "Mi Tesis", tasks: [Task(title: "Titulo de la tarea")], status: .completed),
        Project(alias: "Esto es un alias muchooo mas largo de lo normal", title: "titulo7", tasks: [Task(title: "Titulo de la tarea")], status: .inProgress)
    ]
    
}
