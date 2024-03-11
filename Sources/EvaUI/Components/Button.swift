//
//  Button.swift
//
//
//  Created by Matúš Klasovitý on 11/01/2024.
//

import Foundation
import SwiftHtml

struct Button<Label: View>: View, Identifiable, HasAction, HTMLRepresentable {
    
    let id: String
    let label: Label
    let action: () -> Void
    
    init(file: String = #file, line: Int = #line, action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        var hasher = Hasher()
        hasher.combine(file)
        hasher.combine(line)
        
        self.id = hasher.finalize().description
        self.label = label()
        self.action = action
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] {
        [label]
    }
    
    var htmlTag: Tag {
        SwiftHtml.Button()
            .attribute("hx-post", "/eva?triggerId=\(id)")
            .attribute("hx-include", "[name='data']")
            .attribute("hx-target", ".component")
            .attribute("hx-swap", "outerHTML")
            .class("rounded-md bg-indigo-600 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600")
    }
    
}

//struct ReactiveButton<Label: View, Actor: Reactor>: View, Identifiable, HTMLRepresentable {
//    
//    let id: String
//    let label: Label
//    let action: Actor.Action
//    // let action: () -> Void
//    
//    init(file: String = #file, line: Int = #line, reactor: Actor, action: Actor.Action, @ViewBuilder label: () -> Label) {
//        var hasher = Hasher()
//        hasher.combine(file)
//        hasher.combine(line)
//        
//        self.id = hasher.finalize().description
//        self.label = label()
//        self.action = action
//    }
//    
//    var body: some View {
//        NeverView()
//    }
//    
//    var children: [any View] {
//        [label]
//    }
//    
//    var htmlTag: Tag {
//        SwiftHtml.Button()
//            .attribute("hx-post", "/eva?triggerId=\(id)")
//            .attribute("hx-include", "[name='data']")
//            .attribute("hx-target", ".component")
//            .attribute("hx-swap", "outerHTML")
//            .class("rounded-md bg-indigo-600 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600")
//    }
//    
//}


struct PrimaryButton<Label: View, Action: Codable>: View, Identifiable, HTMLRepresentable {
    
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
        SwiftHtml.Button()
            .attribute("id", id)
            .attribute("hx-post", "/eva2")
//            .attribute("hx-include", "[name='state'], [name='id'], #\(id) > [name='action']")
            .attribute("hx-vals", "js:{ ...sendData(event) }")
            .attribute("hx-ext", "json-enc")
            .attribute("hx-target", ".component")
            .attribute("hx-swap", "outerHTML")
            .class("rounded-md bg-indigo-600 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600")
    }
    
}
