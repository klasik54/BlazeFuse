//
//  Button.swift
//
//
//  Created by Matúš Klasovitý on 11/01/2024.
//

import Foundation
import SwiftHtml

enum Handler {
    
    case trigger(any Codable)
    case dispatch(any Event)
    
}

struct Button<Label: View>: View, HTMLRepresentable {
    
    let label: Label
    let handler: Handler
    
    init(onClick: Handler, @ViewBuilder label: () -> Label) {
        self.label = label()
        self.handler = onClick
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] {
        [label]
    }
    
    var encodedAction: String {
        switch handler {
        case .trigger(let action):
            let data = try! JSONEncoder().encode(action)
            return String(data: data, encoding: .utf8)!.replacingOccurrences(of: #"""#, with: #"&quot;"#)

        case .dispatch(let event):
            let data = try! JSONEncoder().encode(event)
            return String(data: data, encoding: .utf8)!.replacingOccurrences(of: #"""#, with: #"&quot;"#)
        }
    }
    
    var htmlTag: Tag {
        switch handler {
        case .trigger:
            SwiftHtml.Button()
                .attribute("data-node-type", "trigger")
                .attribute("data-action-data", encodedAction)
                .attribute("hx-disinherit", "*")
                .attribute("hx-post", "/fuse/action")
                .attribute("hx-ext", "json-enc")
                .attribute("hx-target", "closest [data-node-type='component']")
                .attribute("hx-swap", "outerHTML")
                .class("rounded-md bg-indigo-600 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600")

        case .dispatch(let event):
            SwiftHtml.Button()
                .attribute("data-node-type", "dispatcher")
                .attribute("data-event-name", type(of: event).identifier)
                .attribute("data-event-data", encodedAction)
                .class("rounded-md bg-indigo-600 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600")
        }
    }
    
}
