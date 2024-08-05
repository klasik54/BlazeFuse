//
//  TextEditor.swift
//
//
//  Created by Matúš Klasovitý on 05/04/2024.
//

import Foundation
import SwiftHtml

struct TextEditor: View, HTMLRepresentable {
    
    private let placeholder: String
    private let name: String
    private let value: String?
    
    init(_ placeholder: String, name: String) {
        self.placeholder = placeholder
        self.name = name
        self.value = nil
    }
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self.name = text.name
        self.value = text.wrappedValue
    }
    
    var body: some View {
        NeverView()
    }
    
    var htmlTag: SwiftHtml.Tag {
        return Div().class("grow-wrap")
    }
    
    var children: [any View] {
        [TextArea(placeholder: placeholder, name: name, value: value)]
    }
    
}


private struct TextArea: View, HTMLRepresentable {
    
    private let placeholder: String
    private let name: String
    private let value: String?
    
    init(placeholder: String, name: String, value: String?) {
        self.placeholder = placeholder
        self.name = name
        self.value = value
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] = []
    
    var htmlTag: SwiftHtml.Tag {
        let textArea = Textarea(value)
            .attribute("data-node-type", "input")
            .attribute("placeholder", placeholder)
            .attribute("hx-post", "/fuse/action")
            .attribute("name", name)
            .attribute("onInput", "this.parentNode.dataset.replicatedValue = this.value")
        
        if value != nil{
            textArea
                .attribute("hx-trigger", "keyup changed") // delay:500ms
                .attribute("hx-target", "closest [data-node-type='component']")
                .attribute("hx-swap", "morph")
                .attribute("hx-ext", "morph")
        }
        
        return textArea
    }
    
}
