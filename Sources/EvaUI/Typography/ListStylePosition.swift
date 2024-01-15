//
//  ListStylePosition.swift
//
//
//  Created by Matúš Klasovitý on 15/01/2024.
//

import Foundation
import SwiftHtml

struct ListStylePosition {
    
    static let inside = ListStylePosition(className: "list-inside")
    static let outside = ListStylePosition(className: "list-outside")
    
    let className: String
    
}

extension Tag {
    
    func listStylePosition(_ position: ListStylePosition) -> Self {
        self.class(add: position.className)
    }
    
}
