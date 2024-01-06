//
//  Extensions.swift
//
//
//  Created by Matúš Klasovitý on 06/01/2024.
//

import Foundation
import SwiftHtml

struct Font {
    
    static let extraLargeTitle2 = Font(className: "text-7xl font-bold")
    static let extraLargeTitle = Font(className: "text-6xl font-bold")
    static let largeTitle = Font(className: "text-5xl font-bold")
    static let title = Font(className: "text-4xl font-bold")
    static let title2 = Font(className: "text-3xl font-bold")
    static let title3 = Font(className: "text-2xl font-bold")
    static let headline = Font(className: "text-xl font-semibold")
    static let subheadline = Font(className: "text-lg font-semibold")
    static let body = Font(className: "text-base font-medium")
    static let callout = Font(className: "text-sm font-medium")
    static let caption = Font(className: "text-xs font-medium")
//    static let caption2 = Font(className: "text-xxxs ")
//    static let footnote = Font(className: "text-xs")

    let className: String
    
}

extension Tag {
    
    func font(_ font: Font) -> Self {
        self.class(font.className)
    }
    
}
