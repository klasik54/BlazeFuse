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
    let childrenStates: [String: Data]
    
    enum CodingKeys: CodingKey {
        
        case id
        case childrenStates
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        let childrenStates = try container.decode([ChildrenState].self, forKey: .childrenStates)
        
        var items = [String: Data]()
        for childrenState in childrenStates {
            items[childrenState.id] = childrenState.state
        }
        
        self.childrenStates = items
    }

}

func evaUIRouteHandler(_ request: HBRequest) async throws -> HBResponse {
    let updateComponentRawRequest = try request.decode(as: ComponentID.self)
    let className = "BlazeFuse.\(updateComponentRawRequest.id)"
    let viewClass: AnyClass? = NSClassFromString(className)
    guard let objectType = viewClass as? NSObject.Type else {
        return HBResponse(status: .internalServerError)
    }
    let viewObject = objectType.init()
    
    guard let anyComponent = viewObject as? any ComponentType else {
        return HBResponse(status: .internalServerError)
    }
    let componentType = type(of: anyComponent)
    
    do {
        let view = try await getComponent(from: viewObject, componentType: componentType, request: request)

        return HBResponse(
            status: .ok,
            headers: [
                "Content-Type": "text/html"
            ],
            body: .byteBuffer(ByteBuffer(string: ViewRenderer.shared.renderComponent(view, childrenStates: updateComponentRawRequest.childrenStates)))
        )
    } catch {
        print(error)
        return HBResponse(status: .internalServerError)
    }
    
    func getComponent<T: ComponentType>(from nsObject: NSObject, componentType: T.Type, request: HBRequest) async throws -> some View {
        guard let component = nsObject as? T else {
            fatalError("Not Component")
        }
        let updateRequest = try request.decode(as: UpdateComponentRequest<T>.self)
        component.props = updateRequest.props
        let mutatedState = await component.mutate(
            state: updateRequest.state,
            action: updateRequest.action
        )
//        component.currentState = mutatedState

        return component.wrapper(state: mutatedState)
    }

}
