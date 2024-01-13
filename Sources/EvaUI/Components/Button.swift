//
//  Button.swift
//
//
//  Created by Matúš Klasovitý on 11/01/2024.
//

import Foundation
import SwiftHtml

protocol Actionable {
    
    var action: () -> Void { get }
    
}


struct Button<Label: View>: View, Tagable, Identifiable, Actionable {
    
    let id: String
    let label: Label
    let action: () -> Void
    
    init(file: String = #file, line: Int = #line, action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        var hasher = Hasher()
        hasher.combine(file)
        hasher.combine(line)
        
        self.id = hasher.finalize().description
        self.label = label()
        self.action = action
    }
    
    var body: some View {
        self
    }
    
    var tag: Tag {
        SwiftHtml.Button {
            ViewRenderer().tagFrom(view: label)
        }
        .attribute("hx-post", "/eva?triggerId=\(id)")
        .attribute("hx-include", "[name='data']")
        .attribute("hx-target", ".component")
        .class("rounded-md bg-indigo-600 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600")
    }
    
}
