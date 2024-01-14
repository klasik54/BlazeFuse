//
//  Group.swift
//  
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import SwiftHtml

struct Group<Content: View>: View, Tagable {
    
    let content: Content
    private let viewRenderer = ViewRenderer()
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] {
        [content]
    }
    
    var tag: Tag {
        Div {
            viewRenderer.tagFrom(view: content)
        }
    }
    
}
