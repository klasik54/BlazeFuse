//
//  ListItem.swift
//
//
//  Created by Matúš Klasovitý on 20/01/2024.
//

import SwiftHtml

struct ListItem<Content: View>: View, HTMLRepresentable {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NeverView()
    }
    
    var htmlTag: Tag = Li()
    
    var children: [any View] {
        [content]
    }
    
}
