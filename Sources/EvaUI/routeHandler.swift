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
    guard let anyComponentType = viewClass as? any ComponentType.Type else {
        return HBResponse(status: .internalServerError)
    }
    
    do {
        let view = try await getComponent(from: anyComponentType, request: request)

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
    
    func getComponent<T: ComponentType>(from anyComponentType: T.Type, request: HBRequest) async throws -> some View {
        let updateRequest = try request.decode(as: UpdateComponentRequest<T>.self)
        let component = anyComponentType.init(props: updateRequest.props)
        
        let mutatedState = await component.mutate(
            props: updateRequest.props,
            state: updateRequest.state,
            action: updateRequest.action
        )
        
        return component.wrapper(state: mutatedState)
    }

}
