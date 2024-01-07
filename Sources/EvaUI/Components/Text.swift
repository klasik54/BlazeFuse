//
//  Text.swift
//
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import SwiftHtml

struct Text: View, Tagable {
    
    let text: String
    
    private init(text: String, tag: Tag) {
        self.text = text
        self.tag = tag
    }
    
    init(_ text: String) {
        self.text = text
        self.tag = P(text)
    }
    
    var body: some View {
        self
    }
    
    var tag: Tag
    
}

extension Text {
    
    func fontWeight(_ weight: FontWeight) -> Text {
        return Text(text: text, tag: tag.fontWeight(weight))
    }
    
    func font(_ font: Font) -> Text {
        return Text(text: text, tag: tag.font(font))
    }
    
    func fontSize(_ size: FontSize) -> Text {
        return Text(text: text, tag: tag.fontSize(size))
    }
    
    func fontFamily(_ family: FontFamily) -> Text {
        return Text(text: text, tag: tag.fontFamily(family))
    }
    
}
