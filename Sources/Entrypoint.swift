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

@main
enum Entrypoint {
    
    static func main() async throws {
//        ComponentsRegister.shared.register(NewStateView())
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
            return HelloView(props: .init())
        }
        
        app.router.get("reactor") { request in
            return MyReactiveView()
        }
        
        app.router.get("counter") { request in
            return CounterView(props: .init())
        }
        
        app.router.post("eva", use: evaUIRouteHandler)
        
//        struct EmptyRequest: Decodable {}
        struct ComponentID: Decodable {
            let id: String
        }
        
        app.router.post("eva2") { (request: HBRequest) -> HBResponse in
            let updateComponentRawRequest = try request.decode(as: ComponentID.self)
//            let stateString = updateComponentRawRequest.state.replacingOccurrences(of: "&quot;", with: #"""#)
//            let actionString = updateComponentRawRequest.action.replacingOccurrences(of: "&quot;", with: #"""#)
            
//            guard let stateData = stateString.data(using: .utf8),
//                  let actionData = actionString.data(using: .utf8) else {
//                throw HBHTTPError(.badRequest)
//            }
//            let data = Data()
//            let id = "string"
            let className = "BlazeFuse.\(updateComponentRawRequest.id)"
            let viewClass: AnyClass? = NSClassFromString(className)
            guard let objectType = viewClass as? NSObject.Type else {
                return HBResponse(status: .internalServerError)
//                fatalError("Not NSObject")
            }
            let viewObject = objectType.init()
            
            guard let anyComponent = viewObject as? any Component else {
                return HBResponse(status: .internalServerError)
            }
            let componentType = type(of: anyComponent)
            
            let view = await getComponent(from: viewObject, componentType: componentType, request: request)
            
//            let stateType = type(of: someSomponent)
            
//            let currentState = try! JSONDecoder().decode(stateType.State.self, from: data)
            
            
//            let componentType = type(of: component)
            
//            let currentState = getComponentState(component: someSomponent, from: data)
//            let dispatchedAction = getDispatchetAction(component: someSomponent, from: data)
//            
////            someSomponent.mutate(state: currentState, action: dispatchedAction)
//            
//            
//            func getComponentState<T: Component>(component: T, from: Data) -> T.State {
//                let currentState = try! JSONDecoder().decode(T.State.self, from: data)
//                return currentState
//            }
//            
//            func getDispatchetAction<T: Component>(component: T, from: Data) -> T.Action {
//                let action = try! JSONDecoder().decode(T.Action.self, from: data)
//                return action
//            }
//            
            
            func getComponent<T: Component>(from nsObject: NSObject, componentType: T.Type, request: HBRequest) async -> some View {
                guard let component = nsObject as? T else {
                    fatalError("Not Component")
                }
                let updateRequest = try! request.decode(as: UpdateComponentRequest<T>.self)
//                let state = try! JSONDecoder().decode(T.State.self, from: stateData)
//                let dispatchedAction = try! JSONDecoder().decode(T.Action.self, from: actionData)
                let mutatedState = await component.mutate(
                    state: updateRequest.state,
                    action: updateRequest.action
                )
                component.currentState = mutatedState

                return component.wrapper() // component.render(state: mutatedState)
            }
            
//            let component = getComponent(from: viewObject)// .mutate(state: currentState, action: dispatchedAction)
            
//            let currentState = try! JSONDecoder().decode(componentType.State, from: data)

            
            
//            component.mutate(state: <#T##Component.State#>, action: <#T##Component.Action#>)
            
            
//            let anyView = ComponentsRegister.shared.components[id]!
//            let type = type(of: anyView).self
//            let component = await get(viewType: type)
            
//            let html = ViewRenderer.shared.renderComponent(component)
            
            
            return HBResponse(
                status: .ok,
                headers: [
                    "Content-Type": "text/html"
                ],
                body: .byteBuffer(ByteBuffer(string: ViewRenderer.shared.renderComponent(view)))
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
                props: .init()
            )
        }
        app.router.post("login", use: AuthController.index)
        app.router.get("register", use: AuthController.register)
        
        try await app.asyncRun()
    }
    
}
