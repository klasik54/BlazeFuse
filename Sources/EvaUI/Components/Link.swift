//
//  Link.swift
//
//
//  Created by Matúš Klasovitý on 15/01/2024.
//

import Foundation
import SwiftHtml

struct Link<Content: View>: View, HTMLRepresentable {
    
    let href: String
    let content: Content
    
    init(href: String, @ViewBuilder content: () -> Content) {
        self.href = href
        self.content = content()
    }
    
    var body: some View {
        NeverView()
    }
    
//    var tag: Tag {
//        A {
//            ViewRenderer.shared.tagFrom(view: content)
//        }.href(href)
//    }
    
    var parentTag: Tag? {
        A().href(href)
    }

    var children: [any View] {[
        content
    ]}
    
}

extension Link where Content == Text {
    
    init(href: String, _ title: String) {
        self.href = href
        self.content = Text(title)
    }
    
}

