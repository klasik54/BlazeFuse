//
//  TriggerEventRequest.swift
//
//
//  Created by Matúš Klasovitý on 29/03/2024.
//

import Foundation

struct TriggerEventRequest<T: ComponentType>: Decodable {
    
    let props: T.Props
    let state: T.State
    let eventName: String
    let eventPayload: Data
    
}
