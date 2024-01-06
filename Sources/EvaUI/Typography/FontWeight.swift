//
//  FontWeight.swift
//
//
//  Created by Matúš Klasovitý on 06/01/2024.
//

import Foundation
import SwiftHtml

struct FontWeight {
    
    static let thin = FontWeight(className: "font-thin")
    static let extralight = FontWeight(className: "font-extralight")
    static let light = FontWeight(className: "font-light")
    static let normal = FontWeight(className: "font-normal")
    static let medium = FontWeight(className: "font-medium")
    static let semibold = FontWeight(className: "font-semibold")
    static let bold = FontWeight(className: "font-bold")
    static let extrabold = FontWeight(className: "font-extrabold")
    static let black = FontWeight(className: "font-black")
    
    let className: String
    
}

extension Tag {
    
    func fontWeight(_ weight: FontWeight) -> Self {
        self.class(weight.className)
    }
    
}
