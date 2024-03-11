//
//  StatefulViewWrapper.swift
//  
//
//  Created by Matúš Klasovitý on 14/01/2024.
//

import Foundation
import SwiftHtml

struct StatefulViewWrapper<Content: View>: View, HTMLRepresentable {
    
    let id: String
    let view: Content
    let jsonData: String
    
    init(
        id: String,
        jsonData: String,
        @ViewBuilder view: () -> Content
    ) {
        self.id = id
        self.jsonData = jsonData
        self.view = view()
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] {
        [
            HiddenInput(name: "id", value: id),
            HiddenInput(name: "state", value: jsonData),
            view
        ]
    }
    
    var htmlTag: Tag {
        Div()
            .id(id)
            .class("component")
    }
    
}

struct HiddenInput: View, HTMLRepresentable {
    
    let name: String
    let value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    var body: some View {
        NeverView()
    }
    
    var htmlTag: Tag {
        Input()
            .class(name)
            .name(name)
            .type(.hidden)
            .value(value)
    }
    
    var children: [any View] = []
    
}

