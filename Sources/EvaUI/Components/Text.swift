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
        self.htmlTag = parentTag
    }
    
    init(_ text: String) {
        self.text = text
        self.htmlTag = P(text)
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] = []
    var htmlTag: Tag
    
}

extension Text {
    
    func fontWeight(_ weight: FontWeight) -> Text {
        return Text(text: text, parentTag: htmlTag.fontWeight(weight))
    }
    
    func font(_ font: Font) -> Text {
        return Text(text: text, parentTag: htmlTag.font(font))
    }
    
    func fontSize(_ size: FontSize) -> Text {
        return Text(text: text, parentTag: htmlTag.fontSize(size))
    }
    
    func fontFamily(_ family: FontFamily) -> Text {
        return Text(text: text, parentTag: htmlTag.fontFamily(family))
    }
    
}

