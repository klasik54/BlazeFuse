//
//  VStack.swift
//
//
//  Created by Matúš Klasovitý on 06/01/2024.
//

import Foundation
import SwiftHtml

enum HorizontalAlignment: String {
    
    case left = "left"
    case center = "center"
    case right = "right"
    
}

//struct VStack: View {
//    
//    let spacing: Int
//    let alignment: HorizontalAlignment
//    
//    let content: Tag
//    
//    init(spacing: Int = 16, alignment: HorizontalAlignment = .center, @TagBuilder content: () -> Tag) {
//        self.spacing = spacing
//        self.alignment = alignment
//        self.content = content()
//    }
//    
//    var body: Tag {
//        Div {
//            content
//        }
//        .class(add: "flex flex-col gap-[\(spacing)px] items-\(alignment.rawValue)")
//    }
//    
//}
