//
//  EventListener.swift
//  
//
//  Created by Matúš Klasovitý on 28/03/2024.
//

import Foundation

protocol EventListenerType {
    
    var eventIdentifier: String { get }
    
}

struct EventListener<E: Event, State: Codable>: EventListenerType {
    
    let eventType: E.Type
    let listenerFunction: (E, State) async -> State
    
    init(for eventType: E.Type, listenerFunction: @escaping (E, State) async -> State) {
        self.eventType = eventType
        self.listenerFunction = listenerFunction
    }
    
    var eventIdentifier: String {
        E.identifier
    }
    
}
