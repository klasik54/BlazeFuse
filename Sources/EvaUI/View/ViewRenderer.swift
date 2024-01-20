//
//  ViewRenderer.swift
//
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import SwiftHtml

final class ViewRenderer {
    
    static let shared = ViewRenderer()
    
    private init() {}
    
    func renderPage(_ view: some View) -> String {
        let document = Document(.html) {
            Html {
                Head {
                    Script()
                        .src("https://cdn.tailwindcss.com")
                    
                    Script()
                        .src("https://unpkg.com/htmx.org@1.9.10")
                        .integrity("sha384-D1Kt99CQMDuVetoL1lrYwg5t+9QdHe7NLX/SoJYkXDFfX37iInKRy5xLSi8nO7UC")
                        .crossorigin(.anonymous)
                }
                
                tagFrom2(view: view, parentTag: Body())
            }
        }
        
        let html = DocumentRenderer().render(document)
        
        return html
    }
    
    func renderComponent(_ view: some View) -> String {
        let document = Document(.html) {
            // tagFrom(view: view)
            tagFrom2(view: view, parentTag: Div())
        }
        let html = DocumentRenderer().render(document)
        
        return html
    }
    
    func tagFrom2<T: View>(view: T, classList: [String] = [], parentTag: Tag) -> Tag {
        if let htmlRepresentable = view as? any HTMLRepresentable & View {
            return renderHTMLRepresentableView(view: htmlRepresentable, parentTag: parentTag)
        } else {
            return tagFrom2(view: view.body, parentTag: parentTag)
        }
    }
    
    func renderHTMLRepresentableView<T: View & HTMLRepresentable>(view: T, parentTag: Tag) -> Tag {
        var children = parentTag.children

        for child in view.children {
            if let childWrapper = view.childWrapper {
                let child = tagFrom2(view: child, parentTag: view.parentTag)
                if child.node.name == "group" {
                    let groupChildren = getGroupTagChildren(groupTag: child)
                    for child in groupChildren {
                        let wrappingTag = createCopyTag(tag: childWrapper, children: [child])
                        children.append(wrappingTag)
                    }
                } else {
                    let wrappingTag = createCopyTag(tag: childWrapper, children: [child])
                    children.append(wrappingTag)
                }
            } else {
                let childTag = tagFrom2(view: child, parentTag: view.parentTag)
                children.append(childTag)
            }
        }
        
        return createCopyTag(tag: view.parentTag, children: children)
    }
    
    func createCopyTag(tag: Tag, children: [Tag]) -> Tag {
        let tagCopy = Tag(children)
        tagCopy.setAttributes(tag.node.attributes)
        tagCopy.setContents(tag.node.contents)
        tagCopy.node = tag.node
        
        return tagCopy
    }
    
    func getGroupTagChildren(groupTag: Tag) -> [Tag] {
        var children: [Tag] = []
        
        for child in groupTag.children {
            if child.node.type == .group {
                children.append(contentsOf: getGroupTagChildren(groupTag: child))
            } else {
                children.append(child)
            }
        }
        
        return children
    }

}

protocol HTMLRepresentable {
    
    var parentTag: Tag { get }
    var children: [any View] { get }
    var childWrapper: Tag? { get }
    
}

extension HTMLRepresentable {
    
    var childWrapper: Tag? { nil }
    
}

