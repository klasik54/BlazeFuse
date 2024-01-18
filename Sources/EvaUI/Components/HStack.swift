//
//  HStack.swift
//  
//
//  Created by Matúš Klasovitý on 18/01/2024.
//

import SwiftHtml

enum VerticalAlignment: String {
    
    case top = "start"
    case bottom = "end"
    case center = "center"
    
}

struct HStack<Content: View>: View, Tagable {
    
    let alignment: VerticalAlignment
    let spacing: Float
    let content: Content
    
    init(alignment: VerticalAlignment = .center, spacing: Float = 16, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        NeverView()
    }
    
    var tag: Tag {
        Div {
            if let tupleView = content as? AnyTupleView {
                for child in tupleView.children {
                    ViewRenderer.shared.tagFrom(view: child)
                }
            } else {
                ViewRenderer.shared.tagFrom(view: content)
            }
        }.class("flex gap-[\(spacing)px] items-\(alignment.rawValue)")
    }
    
    var children: [any View] {[
        content
    ]}
    
}
