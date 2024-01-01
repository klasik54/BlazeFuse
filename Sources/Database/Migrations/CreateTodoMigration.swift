//
//  CreateTodoMigration.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import FluentKit

struct CreateTodoMigration: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(Todo.schema)
            .field("id", .int, .identifier(auto: true), .required)
            .field("title", .string, .required)
            .field("completed", .bool, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Todo.schema).delete()
    }
    
}
