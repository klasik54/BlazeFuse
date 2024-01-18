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
        let body = Body()
        let tag = tagFrom2(view: view, parentTag: body)

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
                
                tag
                
//                Body {
//                    tagFrom(view: view)
//                }
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
    
//    func tagFrom<T: View>(view: T, classList: [String] = []) -> Tag {
//        var classList = classList
//        let mirror = Mirror(reflecting: view)
//        if let stateFullView = view as? any StatefulView {
//            StatefulViewRepository.shared.registerStateFullView(view: stateFullView)
//        }
//        let view = if let stateFullView = view as? any StatefulView {
//            stateFullView.wrapper
//        } else {
//            view
//        }
//        
//        for child in mirror.children {
//            if let viewModifier = child.value as? ViewModifier {
//                classList.append(viewModifier.className)
//                if let tag = viewModifier.tag {
//                    return tag
//                        .class(add: classList.joined(separator: " "))
//                }
//            }
//        }
//        
//        if let view = view as? Tagable {
//            return view.tag
//                .class(add: classList.joined(separator: " "))
//        }
//      
//        return tagFrom(view: view.body, classList: classList)
//    }
    
    func tagFrom2<T: View>(view: T, classList: [String] = [], parentTag: Tag) -> Tag {
        var children: [Tag] = parentTag.children
        
        if let htmlRepresentable = view as? HTMLRepresentable {
            for child in htmlRepresentable.children {
                let parentTag = if let htmlParentTag = htmlRepresentable.parentTag {
                    htmlParentTag
                } else {
                    parentTag
                }
                
                let childTag = tagFrom2(view: child, parentTag: parentTag)
                
                children.append(childTag)
            }
        } else {
            let childTag = tagFrom2(view: view.body, parentTag: parentTag)
            
            children.append(childTag)
        }
        

        
        
        let newTag = Tag(children)
        newTag.setAttributes(parentTag.node.attributes)
        newTag.setContents(parentTag.node.contents)
        print("Parent: \(parentTag.node.name)")
        print("New tag: \(newTag.node.name)")
        // newTag.class(parentTag.node.)
        
        return newTag
    }
    
}

protocol HTMLRepresentable {
    
    var parentTag: Tag? { get }
    var children: [any View] { get }
    
}

//extension Tag {
//
//    func copyNode(node: Node) {
//        self.node = node
//    }
//    
//}

class CopyTag: Tag {
    
    override class func createNode() -> Node {
        No
    }
    
//    override class func createNode() -> Node {
//        tag.node
////        Node(type: .standard, name: tag.node.name)
//    }
    
    let name: String
    let tag: Tag
    
    init(tag: Tag) {
        self.tag = tag
        self.name = tag.node.name!
        self.node = Node()
        super.init(tag.children)
    }
    
    
}
