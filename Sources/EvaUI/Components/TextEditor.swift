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
        let textArea = Textarea(value)
            .attribute("data-node-type", "input")
            .attribute("placeholder", placeholder)
            .attribute("hx-post", "/fuse/action")
            .attribute("name", name)
        
        if value != nil{
            textArea
                .attribute("hx-trigger", "keyup changed") // delay:500ms
                .attribute("hx-target", "closest [data-node-type='component']")
                .attribute("hx-swap", "morph")
                .attribute("hx-ext", "morph")
        }
        
        return textArea
    }
    
    var children: [any View] {
        []
    }
    
}
