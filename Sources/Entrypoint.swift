//
//  Entrypoint.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import Hummingbird
import HummingbirdFluent
import FluentPostgresDriver

@main
enum Entrypoint {
    
    static func main() async throws {
        let app = HBApplication(configuration: .init(address: .hostname("127.0.0.1", port: 8080)))
        app.decoder = AppDecoder()
        app.addFluent()
        app.fluent.migrations.add(CreateTodoMigration())
        
        app.fluent.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
            hostname: "localhost",
            port: 5432,
            username: "postgres",
            password: "",
            database: "blaze",
            tls: .prefer(try .init(configuration: .clientDefault)))
        ), as: .psql)
        
        try await app.fluent.migrate()
        
        app.router.get("hello") { request -> String in
            return "Now"
        }
        
        app.router.get("example") { request in
            return HelloView(
                title: "Hello from example"
            )
        }
        app.router.post("login", use: AuthController.index)
        app.router.get("register", use: AuthController.register)
        
        try await app.asyncRun()
    }
    
}
