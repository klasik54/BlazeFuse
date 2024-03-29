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
            views.append(
                EventListenerInput(listener: listener)
                // HiddenInput(name: "listener", value: listener.eventIdentifier)
            )
        }
        
        return views
    }
    
    var htmlTag: Tag {
        Div()
            .id(id)
            .class("component")
    }
    
}


struct EventListenerInput: View, HTMLRepresentable {
    
    let listener: any EventListenerType
    
    init(listener: any EventListenerType) {
        self.listener = listener
    }
    
    var body: some View {
        NeverView()
    }
    
    var htmlTag: Tag {
        Input()
            .name("listener")
            .type(.hidden)
            .value(listener.eventIdentifier)
            .attribute("hx-disinherit", "*")
            .attribute("hx-trigger", "\(listener.eventIdentifier) from:document")
            .attribute("hx-post", "/fuse/event")
            .attribute("hx-target", "closest .component")
            .attribute("hx-swap", "outerHTML")
            .attribute("hx-ext", "json-enc")
    }
    
    var children: [any View] = []
    
}
