//
//  FuseRequest.swift
//  
//
//  Created by Matúš Klasovitý on 29/03/2024.
//

import Foundation

struct FuseRequest: Decodable {
    
    let componentId: String
    let componentName: String
    let childrenStates: [String: Data]
    
    enum CodingKeys: String, CodingKey {
        
        case componentId
        case componentName
        case childrenStates
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.componentId = try container.decode(String.self, forKey: .componentId)
        self.componentName = try container.decode(String.self, forKey: .componentName)
        let childrenStates = try container.decode([ChildrenState].self, forKey: .childrenStates)
        
        var items = [String: Data]()
        for childrenState in childrenStates {
            items[childrenState.id] = childrenState.state
        }
        
        self.childrenStates = items
    }

}
