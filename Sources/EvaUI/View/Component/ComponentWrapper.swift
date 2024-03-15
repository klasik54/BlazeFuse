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
    
    init(
        id: String,
        jsonState: String,
        jsonProps: String,
        @ViewBuilder view: () -> Content
    ) {
        self.id = id
        self.jsonState = jsonState
        self.jsonProps = jsonProps
        self.view = view()
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] {
        [
            HiddenInput(name: "id", value: id),
            HiddenInput(name: "state", value: jsonState),
            HiddenInput(name: "props", value: jsonProps),
            view
        ]
    }
    
    var htmlTag: Tag {
        Div()
            .id(id)
            .class("component")
    }
    
}
