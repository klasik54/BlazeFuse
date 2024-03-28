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
    let view: Content
    let jsonState: String
    let jsonProps: String
    let listeners: [EventListenerType]
    
    init(
        id: String,
        jsonState: String,
        jsonProps: String,
        listeners: [EventListenerType],
        @ViewBuilder view: () -> Content
    ) {
        self.id = id
        self.jsonState = jsonState
        self.jsonProps = jsonProps
        self.listeners = listeners
        self.view = view()
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] {
        var views: [any View] = [
            HiddenInput(name: "id", value: id),
            HiddenInput(name: "state", value: jsonState),
            HiddenInput(name: "props", value: jsonProps),
            view
        ]
        
        for listener in listeners {
            views.append(HiddenInput(name: "listener", value: listener.eventIdentifier))
        }
        
        return views
    }
    
    var htmlTag: Tag {
        Div()
            .id(id)
            .class("component")
    }
    
}
