//
//  Button.swift
//
//
//  Created by Matúš Klasovitý on 11/01/2024.
//

import Foundation
import SwiftHtml

struct Button<Label: View, Action: Codable>: View, Identifiable, HTMLRepresentable {
    
    let id: String
    let label: Label
    let action: Action
    
    init(file: String = #file, line: Int = #line, onClick: Action, @ViewBuilder label: () -> Label) {
        var hasher = Hasher()
        hasher.combine(file)
        hasher.combine(line)
        let uuidString = UUID().uuidString
        
        var id = ""
        
        for character in uuidString {
            if !character.isNumber {
                id.append(character)
            }
        }
        self.id = id
    
        self.label = label()
        self.action = onClick
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
        let data = try! JSONEncoder().encode(action)
        return String(data: data, encoding: .utf8)!.replacingOccurrences(of: #"""#, with: #"&quot;"#)
    }
    
    var htmlTag: Tag {
        if let event = action as? any Event {
            SwiftHtml.Button()
                .attribute("id", id)
//                .attribute("class", "dispatcher")
                .attribute("name", "dispatcher")
                .attribute("value", type(of: event).identifier)
                .attribute("data", encodedAction)
                .class("rounded-md bg-indigo-600 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600")
        } else {
            SwiftHtml.Button()
                .attribute("id", id)
                .attribute("hx-disinherit", "*")
                .attribute("hx-post", "/fuse/action")
                .attribute("hx-ext", "json-enc")
                .attribute("hx-target", "closest .component")
                .attribute("hx-swap", "outerHTML")
                .class("rounded-md bg-indigo-600 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600")
        }
    }
    
}
