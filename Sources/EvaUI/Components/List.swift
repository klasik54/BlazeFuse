//
//  List.swift
//
//
//  Created by Matúš Klasovitý on 15/01/2024.
//

import SwiftHtml

struct List<Content: View>: View, HTMLRepresentable {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    private init(parentTag: Tag, @ViewBuilder content: () -> Content) {
        self.htmlTag = parentTag
        self.content = content()
    }
    
    var body: some View {
        NeverView()
    }
    
    var htmlTag: Tag = Ul()
    
    var children: [any View] {
        [content]
    }
    
}

extension List {
    
    func listStyle(_ style: ListStyle) -> List {
        return List(parentTag: htmlTag.listStyle(style), content: { content })
    }
    
    func listStylePosition(_ position: ListStylePosition) -> List {
        return List(parentTag: htmlTag.listStylePosition(position), content: { content })
    }
    
}
