//
//  fuseEventRouteHandler.swift
//
//
//  Created by Matúš Klasovitý on 29/03/2024.
//

import Foundation
import Hummingbird

func fuseEventRouteHandler(_ request: HBRequest) async throws -> HBResponse {
    let fuseRequest = try request.decode(as: FuseRequest.self)
    let className = "BlazeFuse.\(fuseRequest.componentName)"
    let viewClass: AnyClass? = NSClassFromString(className)
    guard let anyComponentType = viewClass as? any ComponentType.Type else {
        return HBResponse(status: .internalServerError)
    }
    
    do {
        let view = try await triggerEventOnComponent(from: anyComponentType, componentId: fuseRequest.componentId, request: request)

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

fileprivate func triggerEventOnComponent<T: ComponentType>(from anyComponentType: T.Type, componentId: String, request: HBRequest) async throws -> some View {
    let triggerEventRequest = try request.decode(as: TriggerEventRequest<T>.self)
    let component = anyComponentType.init(id: componentId, props: triggerEventRequest.props)
    let listeners = component.registerListeners()
    let eventListenerType = listeners.first { eventListenerType in
        if eventListenerType.eventIdentifier == triggerEventRequest.eventName {
            return true
        } else {
            return false
        }
    }
    
    guard let eventListenerType else {
        throw HBHTTPError(.badRequest)
    }
    let event = try JSONDecoder().decode(eventListenerType.anyEventType, from: triggerEventRequest.eventPayload)
    let mutatedState = await triggerListenerFunction(for: event, state: triggerEventRequest.state, listeners: listeners)

    return component.wrapper(state: mutatedState)
}

fileprivate func triggerListenerFunction<E: Event, State: Codable>(for event: E, state: State, listeners: [EventListenerType]) async -> State {
    for listenerType in listeners {
        if let listener = listenerType as? EventListener<E, State> {
            return await listener.listenerFunction(event, state)
        }
    }
    
    return state
}
