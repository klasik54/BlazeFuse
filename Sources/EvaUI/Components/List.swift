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
        self.parentTag = parentTag
        self.content = content()
    }
    
    var body: some View {
        NeverView()
    }
    
    var parentTag: Tag? = Ul()
    
    var children: [any View] {
        if let tupleView = content as? HTMLRepresentable {
            return tupleView.children.map { view in ListItem(content: { AnyView(view) }) }
        } else {
            return [ListItem(content: { content })]
        }
    }
    
}

struct AnyView: View, HTMLRepresentable {
    
    let view: any View
    
    init(_ view: any View) {
        self.view = view
    }
    
    var body: some View {
        NeverView()
    }
    
    var parentTag: Tag? = nil
    
    var children: [any View] {
        [view]
    }
    
}

struct ListItem<Content: View>: View, HTMLRepresentable {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NeverView()
    }
    
    var parentTag: Tag? = Li()
    var children: [any View] {[
        content
    ]}
    
}

extension List {
    
    func listStyle(_ style: ListStyle) -> List {
        return List(parentTag: parentTag!.listStyle(style), content: { content })
    }
    
    func listStylePosition(_ position: ListStylePosition) -> List {
        return List(parentTag: parentTag!.listStylePosition(position), content: { content })
    }
    
}
