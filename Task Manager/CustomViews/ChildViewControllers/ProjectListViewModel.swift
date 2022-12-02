//
//  ProjectListViewModel.swift
//  Task Manager
//
//  Created by Duilan on 01/12/22.
//

protocol ProjectListDelegate: AnyObject {
}

class ProjectListViewModel {
    private let repository: ProjectRepository = ProjectRepository()
    weak var delegate: ProjectListDelegate?
}
