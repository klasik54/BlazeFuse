//
//  Todo.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import Foundation
import FluentKit

class Todo: Model {
   
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "completed")
    var completed: Bool
    
    required init() {}
    
    init(id: UUID? = nil, title: String, completed: Bool) {
        self.id = id
        self.title = title
        self.completed = completed
    }
    
}
