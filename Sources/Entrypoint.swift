//
//  Entrypoint.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import Hummingbird

@main
enum Entrypoint {
    
    static func main() async throws {
        let app = HBApplication(configuration: .init(address: .hostname("127.0.0.1", port: 8080)))
        app.decoder = AppDecoder()
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
