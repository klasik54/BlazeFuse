//
//  FontFamily.swift
//  
//
//  Created by Matúš Klasovitý on 06/01/2024.
//

import Foundation
import SwiftHtml

struct FontFamily {
    
    static let sans = FontFamily(className: "font-sans")
    static let serif = FontFamily(className: "font-serif")
    static let mono = FontFamily(className: "font-mono")
    
    let className: String
    
}

extension Tag {
    
    func fontFamily(_ family: FontFamily) -> Self {
        self.class(family.className)
    }
    
}

