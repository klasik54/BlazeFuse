//
//  Button.swift
//
//
//  Created by Matúš Klasovitý on 11/01/2024.
//

import Foundation
import SwiftHtml

struct Button<Label: View>: View, HTMLRepresentable {
    
    let label: Label
    let handler: Handler
    
    enum Handler {
        
        case trigger(any Codable)
        case dispatch(any Event)
        
    }
    
    init(onClick: Handler, @ViewBuilder label: () -> Label) {
        self.label = label()
        self.handler = onClick
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] {
        [
            HiddenInput(name: "action", value: encodedAction),
            label
        ]
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
                .attribute("hx-disinherit", "*")
                .attribute("hx-post", "/fuse/action")
                .attribute("hx-ext", "json-enc")
                .attribute("hx-target", "closest .component")
                .attribute("hx-swap", "outerHTML")
                .class("rounded-md bg-indigo-600 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600")

        case .dispatch(let event):
            SwiftHtml.Button()
                .attribute("name", "dispatcher")
                .attribute("value", type(of: event).identifier)
                .attribute("data", encodedAction)
                .class("rounded-md bg-indigo-600 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600")
        }
    }
    
}
