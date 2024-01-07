//
//  ViewRenderer.swift
//
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import SwiftHtml

class ViewRenderer {
    
    func render(_ view: some View) -> String {
        let document = Document(.html) {
            Html {
                Head {
                    Script()
                        .src("https://cdn.tailwindcss.com")
                }
                
                Body {
                    tagFrom(view: view)
                }
            }
        }
        
        let html = DocumentRenderer().render(document)
        
        return html
    }
    
    func tagFrom<T: View>(view: T, classList: [String] = []) -> Tag {
        print("View", type(of: view))
        print("Body", type(of: view.body))
        var classList = classList
        let mirror = Mirror(reflecting: view)
        
        for child in mirror.children {
            if let viewModifier = child.value as? ViewModifier {
                classList.append(viewModifier.className)
                if let tag = viewModifier.tag {
                    return tag
                        .class(add: classList.joined(separator: " "))
                }
            }
        }
        
        if let view = view as? Tagable {
            return view.tag
                .class(add: classList.joined(separator: " "))
        }
      
        return tagFrom(view: view.body, classList: classList)
    }
    
}
