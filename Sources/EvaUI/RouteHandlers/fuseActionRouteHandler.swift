//
//  fuseActionRouteHandler.swift
//
//
//  Created by Matúš Klasovitý on 29/03/2024.
//

import Foundation
import Hummingbird

func fuseActionRouteHandler(_ request: HBRequest) async throws -> HBResponse {
    let fuseRequest = try request.decode(as: FuseRequest.self)
    let className = "BlazeFuse.\(fuseRequest.componentName)"
    let viewClass: AnyClass? = NSClassFromString(className)
    guard let anyComponentType = viewClass as? any ComponentType.Type else {
        return HBResponse(status: .internalServerError)
    }
    
    do {
        let view = try await getComponent(from: anyComponentType, componentId: fuseRequest.componentId, request: request)

        return HBResponse(
            status: .ok,
            headers: [
                "Content-Type": "text/html"
            ],
            body: .byteBuffer(ByteBuffer(string: ViewRenderer.shared.renderComponent(view, childrenStates: fuseRequest.childrenStates)))
        )
    } catch {
        print(error)
        return HBResponse(status: .internalServerError)
    }
}

fileprivate func getComponent<T: ComponentType>(from anyComponentType: T.Type, componentId: String, request: HBRequest) async throws -> some View {
    let updateRequest = try request.decode(as: UpdateComponentRequest<T>.self)
    let component = anyComponentType.init(id: componentId, props: updateRequest.props)
    
    if let action = updateRequest.action {
        let mutatedState = await component.mutate(
            props: updateRequest.props,
            state: updateRequest.state,
            action: action
        )
        
        return component.wrapper(state: mutatedState)
    }
    
    return component.wrapper(state: updateRequest.state)
}
