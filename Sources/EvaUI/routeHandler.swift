//
//  routeHandler.swift
//  
//
//  Created by Matúš Klasovitý on 14/01/2024.
//

import Foundation
import Hummingbird

struct ComponentID: Decodable {
    
    let id: String

}

func evaUIRouteHandler(_ request: HBRequest) async throws -> HBResponse {
    let updateComponentRawRequest = try request.decode(as: ComponentID.self)
    let className = "BlazeFuse.\(updateComponentRawRequest.id)"
    let viewClass: AnyClass? = NSClassFromString(className)
    guard let objectType = viewClass as? NSObject.Type else {
        return HBResponse(status: .internalServerError)
    }
    let viewObject = objectType.init()
    
    guard let anyComponent = viewObject as? any Component else {
        return HBResponse(status: .internalServerError)
    }
    let componentType = type(of: anyComponent)
    
    let view = await getComponent(from: viewObject, componentType: componentType, request: request)
    
    func getComponent<T: Component>(from nsObject: NSObject, componentType: T.Type, request: HBRequest) async -> some View {
        guard let component = nsObject as? T else {
            fatalError("Not Component")
        }
        let updateRequest = try! request.decode(as: UpdateComponentRequest<T>.self)
        let mutatedState = await component.mutate(
            state: updateRequest.state,
            action: updateRequest.action
        )
        component.currentState = mutatedState

        return component.wrapper()
    }
    
    return HBResponse(
        status: .ok,
        headers: [
            "Content-Type": "text/html"
        ],
        body: .byteBuffer(ByteBuffer(string: ViewRenderer.shared.renderComponent(view)))
    )

}
