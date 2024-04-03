//
//  ComponentWrapper.swift
//  
//
//  Created by Matúš Klasovitý on 14/01/2024.
//

import Foundation
import SwiftHtml

struct ComponentWrapper<Content: View>: View, HTMLRepresentable {
    
    let id: String
    let name: String
    let view: Content
    let jsonState: String
    let jsonProps: String
    let listeners: [EventListenerType]
    
    init(
        id: String,
        name: String,
        jsonState: String,
        jsonProps: String,
        listeners: [EventListenerType],
        @ViewBuilder view: () -> Content
    ) {
        self.id = id
        self.name = name
        self.jsonState = jsonState
        self.jsonProps = jsonProps
        self.listeners = listeners
        self.view = view()
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] {
        [view]
    }
    
    var htmlTag: Tag {
        Div()
            .id(id)
            .attribute("data-name", name)
            .attribute("data-state", jsonState)
            .attribute("data-props", jsonProps)
            .attribute("data-node-type", "component")
            .class(listeners.map { "listener-\($0.eventIdentifier)"}.joined(separator: " "))
            .attribute("hx-ext", "json-enc")
    }
    
}
