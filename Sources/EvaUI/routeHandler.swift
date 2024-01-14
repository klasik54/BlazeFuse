//
//  routeHandler.swift
//  
//
//  Created by Matúš Klasovitý on 14/01/2024.
//

import Foundation
import Hummingbird

func evaUIRouteHandler(_ request: HBRequest) throws -> HBResponse {
    let changeStateRequest = try request.decode(as: ChangeStateRequest.self)
    let jsonString = changeStateRequest.data.replacingOccurrences(of: "&quot;", with: #"""#)
    guard let jsonData = jsonString.data(using: .utf8) else {
        throw HBHTTPError(.badRequest)
    }
    
    let componentId = try JSONDecoder().decode(ChangeStateRequest.JSONData.self, from: jsonData).id
    let triggerId = request.uri.queryParameters["triggerId"]!
    
    let component = try StatefulViewRepository.shared.getStateFullView(by: componentId, from: jsonData)
    let triggerView = findView(by: triggerId, from: component)
    
    if let actionable = triggerView as? HasAction {
        actionable.action()
    }
    
    let html = ViewRenderer.shared.renderComponent(component)
    
    return HBResponse(
        status: .ok,
        headers: [
            "Content-Type": "text/html"
        ],
        body: .byteBuffer(ByteBuffer(string: html))
    )
}
