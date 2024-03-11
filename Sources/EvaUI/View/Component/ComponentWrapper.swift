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
