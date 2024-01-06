//
//  FontSize.swift
//  
//
//  Created by Matúš Klasovitý on 06/01/2024.
//

import Foundation
import SwiftHtml

struct FontSize {
    
    static let xs = FontSize(className: "text-xs")
    static let sm = FontSize(className: "text-sm")
    static let md = FontSize(className: "text-base")
    static let lg = FontSize(className: "text-lg")
    static let xl = FontSize(className: "text-xl")
    static let xl2 = FontSize(className: "text-2xl")
    static let xl3 = FontSize(className: "text-3xl")
    static let xl4 = FontSize(className: "text-4xl")
    static let xl5 = FontSize(className: "text-5xl")
    static let xl6 = FontSize(className: "text-6xl")
    static let xl7 = FontSize(className: "text-7xl")
    static let xl8 = FontSize(className: "text-8xl")
    static let xl9 = FontSize(className: "text-9xl")
    
    let className: String
    
}

extension Tag {
    
    func fontSize(_ size: FontSize) -> Self {
        self.class(size.className)
    }
    
}

