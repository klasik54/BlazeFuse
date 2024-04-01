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
        var views: [any View] = []
//        for listener in listeners {
//            views.append(
//                EventListenerInput(listener: listener, parentName: name, parentId: id)
//            )
//        }
//        var views: [any View] = [
//            
//        ]
        let xx: [any View] = [
            HiddenInput(name: "state", value: jsonState),
            HiddenInput(name: "props", value: jsonProps),
            view
        ]
        
        views.append(contentsOf: xx)
      
        
        return views
    }
    
    var htmlTag: Tag {
        if listeners.isEmpty {
            Div()
                .id(id)
                .attribute("name", name)
                .class("component")
        } else {
            Div()
                .id(id)
                .attribute("name", name)
                .class("component component-\(name)",  listeners.map { "listener-\($0.eventIdentifier)"}.joined(separator: " "))
//                .attribute("hx-trigger", listeners.map { $0.eventIdentifier }.joined(separator: ", "))
//                .attribute("hx-post", "/fuse/event")
//                .attribute("hx-swap", "outerHTML")
                .attribute("hx-ext", "json-enc")
//                .attribute("hx-sync", "closest .component::not(#\\\\\(id)):drop")
                // .attribute("hx-sync", "closest " + listeners.map { ".listener-\($0.eventIdentifier):not([name='\(name)']):drop"}.joined(separator: ", "))
            // :not([name='Receiver'])
//                .attribute("hx-sync", "closest .component-CounterView:queue")
        }

//            .class(add: "component")
        // Listeners
         
    }
    
}


struct EventListenerInput: View, HTMLRepresentable {
    
    let listener: any EventListenerType
    let parentName: String
    let parentId: String
    
    init(listener: any EventListenerType, parentName: String, parentId: String) {
        self.listener = listener
        self.parentName = parentName
        self.parentId = parentId
    }
    
    var body: some View {
        NeverView()
    }
    
    var htmlTag: Tag {
        Input()
            .id(parentId)
            .name("listener")
            .type(.hidden)
            .value(listener.eventIdentifier)
            .attribute("class", "listener")
            .attribute("hx-trigger", "\(listener.eventIdentifier)")
            .attribute("hx-post", "/fuse/event")
            .attribute("hx-target", "closest .component")
            .attribute("hx-swap", "outerHTML")
            .attribute("hx-ext", "json-enc")
            .attribute("hx-sync", "previous .component:abort")
            .attribute("parent-name", parentName)
    }
    
    var children: [any View] = []
    
}
