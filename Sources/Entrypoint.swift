//
//  Entrypoint.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import Hummingbird
import HummingbirdFluent
import FluentPostgresDriver
import Foundation

struct Foo: Decodable {
    
    let data: String
    
    struct Bar: Decodable {
        
        let id: String

    }
    
}


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
//            bb()
            
            return HelloView(props: .init(title: "Hello Swift"))
        }
        
        app.router.post("eva") { request in
            let data = try request.decode(as: Foo.self)
//            print(data.data.replacingOccurrences(of: "&quot;", with: #"""#))
            let jsonString = data.data.replacingOccurrences(of: "&quot;", with: #"""#)
//            print(jsonString)
            let jsonData = jsonString.data(using: .utf8)!
            let bar = try! JSONDecoder().decode(Foo.Bar.self, from: jsonData)
            let triggerId = request.uri.queryParameters["triggerId"]!
            
            let view = StateFullViewRepository.shared.getStateFullView(by: bar.id, from: jsonData)
            
//            let triggerView = findView(by: triggerId, from: view)
//            if let actionable = triggerView as? Actionable {
//                actionable.action()
//            }
            
            
            
            let viewRenderer = ViewRenderer()
            
            let html = viewRenderer.render(view)
            
            
            return HBResponse(
                status: .ok,
                headers: [
                    "Content-Type": "text/html"
                ],
                body: .byteBuffer(ByteBuffer(string: html))
            )
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
                props: .init(title: "Hello from example")
            )
        }
        app.router.post("login", use: AuthController.index)
        app.router.get("register", use: AuthController.register)
        
        try await app.asyncRun()
    }
    
}
