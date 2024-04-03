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
                        .src("https://unpkg.com/htmx.org@1.9.11")
                        .integrity("sha384-0gxUXCCR8yv9FM2b+U3FDbsKthCI66oH5IA9fHppQq9DDMHuMauqq1ZHBpJxQ0J0")
                        .crossorigin(.anonymous)
                    
                    Script()
                        .src("https://unpkg.com/htmx.org/dist/ext/json-enc.js")
                    
                
                    
                    Meta()
                        .charset("UTF-8")
                }
                
                Body {
                    tagFrom(view: view)
                    
                    Script()
                        .src("http://localhost:8080/script.js")
                }
            }
        }
        
        let html = DocumentRenderer().render(document)
        
        return html
    }
    
    func renderComponent(_ view: some View, childrenStates: [String: Foundation.Data]) -> String {
        let document = Document(.html) {
            tagFrom(view: view, childrenStates: childrenStates)
        }
        let html = DocumentRenderer().render(document)
        
        return html
    }

}

// MARK: - Private

private extension ViewRenderer {
    
    func updateComponentState<T: ComponentType>(component: T, from data: Foundation.Data) -> some View {
        let state = try! JSONDecoder().decode(T.State.self, from: data)
        return component.wrapper(state: state)
    }
    
    func getDetaultComponent<T: ComponentType>(component: T) -> some View {
        component.wrapper(state: component.onMount(props: component.getCurrentProps()))
    }
    
    func tagFrom<T: View>(view: T, viewModifiers: [any ViewModifier] = [], childrenStates: [String: Foundation.Data] = [:]) -> Tag {
        if let component = view as? any ComponentType {
            if let componentState = childrenStates[component.getId()] {
                let wrapper = updateComponentState(component: component, from: componentState)
                return tagFrom(view: wrapper, viewModifiers: viewModifiers, childrenStates: childrenStates)
            } else {
                let wrapper = getDetaultComponent(component: component)
                return tagFrom(view: wrapper, viewModifiers: viewModifiers, childrenStates: childrenStates)
            }
        } else if let modifedContent = view as? AnyModifiedContent,
            let viewModifier = modifedContent.anyModifier as? ViewModifier {
            return tagFrom(view: view.body, viewModifiers: viewModifiers + [viewModifier], childrenStates: childrenStates)
        } else if let htmlRepresentable = view as? any HTMLRepresentable & View {
            return renderHTMLRepresentableView(view: htmlRepresentable, viewModifiers: viewModifiers, childrenStates: childrenStates)
        } else {
            return tagFrom(view: view.body, viewModifiers: viewModifiers, childrenStates: childrenStates)
        }
    }
    
    func renderHTMLRepresentableView<T: View & HTMLRepresentable>(
        view: T,
        viewModifiers: [any ViewModifier],
        childrenStates: [String: Foundation.Data] = [:]
    ) -> Tag {
        var children: [Tag] = []

        for childView in view.children {
            let passedViewModifiers: [any ViewModifier] = if view.htmlTag.node.type == .group {
                viewModifiers
            } else {
                []
            }

            let childTag = tagFrom(view: childView, viewModifiers: passedViewModifiers, childrenStates: childrenStates)
            
            if childTag.node.type == .group {
                children.append(contentsOf: childTag.children)
            } else {
                children.append(childTag)
            }
        }
        
        var resultTag = createCopyTag(tag: view.htmlTag, children: children)
        
        if view.htmlTag.node.type != .group {
            for modifier in viewModifiers.reversed() {
                resultTag = applyModifier(viewModifier: modifier, for: resultTag)
            }
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
    
    func applyModifier(viewModifier: any ViewModifier, for tag: Tag) -> Tag {
        if let modifier = viewModifier as? HTMLRepresentable & ViewModifier {
            return createCopyTag(
                tag: modifier.htmlTag,
                children: [tag]
            ).class(add: modifier.className)
        } else {
            return tag.class(add: viewModifier.className)
        }
    }
        
}

