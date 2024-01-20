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
                    Meta()
                        .charset("UTF-8")
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
    
    func tagFrom2<T: View>(view: T, parentTag: Tag, viewModifiers: [any ViewModifier] = []) -> Tag {
        if let stateFullView = view as? any StatefulView {
            StatefulViewRepository.shared.registerStateFullView(view: stateFullView)
            
            return tagFrom2(view: stateFullView.wrapper, parentTag: parentTag)
        } else if let modifedContent = view as? AnyModifiedContent,
            let viewModifier = modifedContent.anyModifier as? ViewModifier {
            return tagFrom2(view: view.body, parentTag: parentTag, viewModifiers: viewModifiers + [viewModifier])
        } else if let htmlRepresentable = view as? any HTMLRepresentable & View {
            return renderHTMLRepresentableView(view: htmlRepresentable, viewModifiers: viewModifiers)
        } else {
            return tagFrom2(view: view.body, parentTag: parentTag, viewModifiers: viewModifiers)
        }
    }
    
    func renderHTMLRepresentableView<T: View & HTMLRepresentable>(view: T, viewModifiers: [any ViewModifier]) -> Tag {
        var children: [Tag] = []

        for child in view.children {
            if let childWrapper = view.childWrapper {
                let child = tagFrom2(view: child, parentTag: view.parentTag)
                if child.node.type == .group {
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
        
        
        var resultTag = createCopyTag(tag: view.parentTag, children: children)

        if viewModifiers.count > 0 && view.parentTag.node.type != .group {
            for modifier in viewModifiers.reversed() {
                if let modifier = modifier as? HTMLRepresentable & ViewModifier {
                    resultTag = createCopyTag(
                        tag: modifier.parentTag,
                        children: [resultTag]
                    ).class(add: modifier.className)
                } else {
                    resultTag = resultTag.class(add: modifier.className)
                }
            }
        } else if view.parentTag.node.type == .group && viewModifiers.count > 0 {
            for (index, _) in children.enumerated() {
                for modifier in viewModifiers.reversed() {
                    let newChild = if let modifier = modifier as? HTMLRepresentable & ViewModifier {
                        createCopyTag(
                            tag: modifier.parentTag,
                            children: [children[index]]
                        ).class(add: modifier.className)
                    } else {
                        children[index].class(add: modifier.className)
                    }
                    children[index] = newChild
                }
            }
            
            resultTag = createCopyTag(tag: view.parentTag, children: children)
        }
        

        
        return resultTag
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

