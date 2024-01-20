//
//  VStack.swift
//
//
//  Created by Matúš Klasovitý on 15/01/2024.
//

import SwiftHtml

enum HorizontalAlignment: String {
    
    case left = "start"
    case center = "center"
    case right = "end"
    
}

struct VStack<Content: View>: View, HTMLRepresentable {
    
    let alignment: HorizontalAlignment
    let spacing: Float
    let content: Content
    
    init(alignment: HorizontalAlignment = .center, spacing: Float = 16, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        NeverView()
    }
    
    var htmlTag: Tag {
        Div()
            .class("flex flex-col gap-[\(spacing)px] items-\(alignment.rawValue)")
    }
    
    var children: [any View] {[
        content
    ]}
    
}
