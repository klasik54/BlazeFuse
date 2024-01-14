//
//  ConditionalContent.swift
//
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import SwiftHtml

struct ConditionalContent<TrueContent: View, FalseContent: View>: View, Tagable {
    
    var trueContent: TrueContent?
    var falseContent: FalseContent?
    
    init(trueContent: TrueContent) {
        self.trueContent = trueContent
        self.falseContent = nil
    }
    
    init(falseContent: FalseContent) {
        self.trueContent = nil
        self.falseContent = falseContent
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] {
        if let trueContent {
            return [trueContent]
        } else if let falseContent {
            return [falseContent]
        } else {
            return []
        }
    }
    
    var tag: Tag {
        if let trueContent {
            return ViewRenderer().tagFrom(view: trueContent)
        } else if let falseContent {
            return ViewRenderer().tagFrom(view: falseContent)
        } else {
            return Div()
        }
    }
    
}
