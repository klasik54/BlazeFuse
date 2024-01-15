//
//  ListStyle.swift
//  
//
//  Created by Matúš Klasovitý on 15/01/2024.
//

import Foundation
import SwiftHtml

struct ListStyle {
    
    static let none = ListStyle(className: "list-none")
    static let disc = ListStyle(className: "list-disc")
    static let decimal = ListStyle(className: "list-decimal")
    
    let className: String
    
}

extension Tag {
    
    func listStyle(_ style: ListStyle) -> Self {
        self.class(add: style.className)
    }
    
}

