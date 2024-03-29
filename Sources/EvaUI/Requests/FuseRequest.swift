//
//  FuseRequest.swift
//  
//
//  Created by Matúš Klasovitý on 29/03/2024.
//

import Foundation

struct FuseRequest: Decodable {
    
    let componentId: String
    let childrenStates: [String: Data]
    
    enum CodingKeys: String, CodingKey {
        
        case componentId
        case childrenStates
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.componentId = try container.decode(String.self, forKey: .componentId)
        let childrenStates = try container.decode([ChildrenState].self, forKey: .childrenStates)
        
        var items = [String: Data]()
        for childrenState in childrenStates {
            items[childrenState.id] = childrenState.state
        }
        
        self.childrenStates = items
    }

}
