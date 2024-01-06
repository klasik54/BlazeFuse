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
        let app = HBApplication(configuration: .init(address: .hostname(
            env("SERVER_HOST", defaultValue: "127.0.0.1"),
            port: env("SERVER_PORT", defaultValue: 8080)
        )))
        app.decoder = AppDecoder()
        app.addFluent()
        app.fluent.migrations.add(CreateTodoMigration())
        
        app.fluent.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
            hostname: env("DB_HOST", defaultValue: "localhost"),
            port: env("DB_PORT", defaultValue: 5432),
            username: env("DB_USERNAME", defaultValue: ""),
            password: env("DB_PASSWORD", defaultValue: ""),
            database: env("DB_DATABASE", defaultValue: ""),
            tls: .prefer(try .init(configuration: .clientDefault)))
        ), as: .psql)
        
        try await app.fluent.migrate()

        app.middleware.add(FileMiddleware())
        
        app.router.get("") { request in
            return MyHelloView() //HelloView(title: "")
        }
        
        app.router.get("hello") { request -> String in
            return "Now"
        }
        
        app.router.get("download") { request in
            guard let fileName = request.uri.queryParameters.get("fileName") else {
                throw HBHTTPError(.badRequest)
            }
            return try Storage.shared.download(path: fileName)
        }
        
        app.router.post("upload") { (request: UploadRequest) -> String in
            let result = Storage.shared.put(file: request.file, on: request.fileName)
            
            return "File uploaded: \(result)"
        }
        
        app.router.get("fileUrl") { request in
            guard let fileName = request.uri.queryParameters.get("fileName") else {
                throw HBHTTPError(.badRequest)
            }

            return Storage.shared.url(path: fileName)?.absoluteString
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
