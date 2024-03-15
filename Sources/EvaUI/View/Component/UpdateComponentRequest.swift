//
//  UpdateComponentRequest.swift
//
//
//  Created by Matúš Klasovitý on 11/03/2024.
//

import Foundation

struct UpdateComponentRequest<T: Component>: Decodable {
    
    let id: String
    let props: T.Props
    let state: T.State
    let action: T.Action
    
}

struct ChildrenState: Decodable {
    
    let id: String
    let state: Data
    
}
