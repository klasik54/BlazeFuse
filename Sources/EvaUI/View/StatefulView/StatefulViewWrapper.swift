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
        [view]
    }
    
    var parentTag: Tag? {
        Div {
            Input()
                .name("data")
                .type(.hidden)
                .value(jsonData)

//            ViewRenderer.shared.tagFrom(view: view)
        }
        .id(id)
        .class("component")
    }
    
}
