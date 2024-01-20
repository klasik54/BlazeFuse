//
//  PaddingModifier.swift
//  
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import SwiftHtml

struct PaddingModifier: ViewModifier, HTMLRepresentable {
    
    let padding: Float
    
    init(padding: Float, content: any View) {
        self.padding = padding
        self.children = [content]
    }
    
    var className: String {
        "p-[\(padding)px]"
    }
    var htmlTag: Tag = Div()
    
    var children: [any View]
    
}

extension View {
    
    func padding(_ padding: Float) -> some View {
        return ModifiedContent(content: self, modifier: PaddingModifier(padding: padding, content: self))
    }
    
}
