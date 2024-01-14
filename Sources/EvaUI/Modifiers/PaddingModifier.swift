//
//  PaddingModifier.swift
//  
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import SwiftHtml

struct PaddingModifier: ViewModifier {
    
    let padding: Float
    
    init(padding: Float, content: any View) {
        self.padding = padding
        self.tag = Div {
            ViewRenderer.shared.tagFrom(view: content)
        }
    }
    
    var className: String {
        "p-[\(padding)px]"
    }
    var tag: Tag?
    
}

extension View {
    
    func padding(_ padding: Float) -> some View {
        return ModifiedContent(content: self, modifier: PaddingModifier(padding: padding, content: self))
    }
    
}
