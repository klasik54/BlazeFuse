//
//  UpdateComponentRequest.swift
//
//
//  Created by Matúš Klasovitý on 11/03/2024.
//

import Foundation

struct UpdateComponentRequest<T: ComponentType>: Decodable {
    
    let props: T.Props
    let state: T.State
    let action: T.Action?
    
}
