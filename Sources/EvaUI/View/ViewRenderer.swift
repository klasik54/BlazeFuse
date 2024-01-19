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
        if let htmlRepresentable = view as? HTMLRepresentable {
            var newParent = if let viewParent = htmlRepresentable.parentTag {
                viewParent
            } else {
                parentTag
            }
            var children = newParent.children
            
            for child in htmlRepresentable.children {
                if let childHTMLRepresentable = child as? HTMLRepresentable,
                   childHTMLRepresentable.parentTag == nil {
                    let tagCopy = Tag(children)
                    tagCopy.setAttributes(newParent.node.attributes)
                    tagCopy.setContents(newParent.node.contents)
                    tagCopy.node = newParent.node
                    
                    newParent = tagFrom2(view: child, parentTag: tagCopy)
                    children = newParent.children
                } else {
                    let childTag = tagFrom2(view: child, parentTag: newParent)
                    children.append(childTag)
                }
            }
            
            let tagCopy = Tag(children)
            tagCopy.setAttributes(newParent.node.attributes)
            tagCopy.setContents(newParent.node.contents)
            tagCopy.node = newParent.node
            
            return tagCopy
        } else {
            return tagFrom2(view: view.body, parentTag: parentTag)
        }
    }
    
}

protocol HTMLRepresentable {
    
    var parentTag: Tag? { get }
    var children: [any View] { get }
    
}

