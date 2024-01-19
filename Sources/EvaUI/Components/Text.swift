//
//  Text.swift
//
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import SwiftHtml

struct Text: View, HTMLRepresentable {
    
    let text: String
    
    private init(text: String, parentTag: Tag) {
        self.text = text
        self.parentTag = parentTag
    }
    
    init(_ text: String) {
        self.text = text
        self.parentTag = P(text)
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] {
        []
    }
    
    var parentTag: Tag?
    
}

extension Text {
    
    func fontWeight(_ weight: FontWeight) -> Text {
        return Text(text: text, parentTag: parentTag!.fontWeight(weight))
    }
    
    func font(_ font: Font) -> Text {
        return Text(text: text, parentTag: parentTag!.font(font))
    }
    
    func fontSize(_ size: FontSize) -> Text {
        return Text(text: text, parentTag: parentTag!.fontSize(size))
    }
    
    func fontFamily(_ family: FontFamily) -> Text {
        return Text(text: text, parentTag: parentTag!.fontFamily(family))
    }
    
}

struct NeverView: View {
    
    var body: some View {
        EmptyView()
    }
    
}
