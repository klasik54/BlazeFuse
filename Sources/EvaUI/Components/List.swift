//
//  List.swift
//
//
//  Created by Matúš Klasovitý on 15/01/2024.
//

import SwiftHtml

struct List<Content: View>: View, Tagable {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.tag = Ul {
            // If there is a more than 1 child, it means it must be TuppleView.
            // TuppleView is Tagable, so we can iterate over it's children and render them.
            if let taggable = content() as? Tagable {
                for child in taggable.children {
                    Li {
                        ViewRenderer.shared.tagFrom(view: child)
                    }
                }
            } else {
                Li {
                    ViewRenderer.shared.tagFrom(view: content())
                }
            }
        }
    }
    
    private init(tag: Tag, @ViewBuilder content: () -> Content) {
        self.tag = tag
        self.content = content()
    }
    
    var body: some View {
        NeverView()
    }
    
    var tag: Tag
    
    var children: [any View] {[
        content
    ]}
    
}

extension List {
    
    func listStyle(_ style: ListStyle) -> List {
        return List(tag: tag.listStyle(style), content: { content })
    }
    
    func listStylePosition(_ position: ListStylePosition) -> List {
        return List(tag: tag.listStylePosition(position), content: { content })
    }
    
}
