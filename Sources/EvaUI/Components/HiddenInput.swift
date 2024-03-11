//
//  HiddenInput.swift
//
//
//  Created by Matúš Klasovitý on 11/03/2024.
//

import Foundation
import SwiftHtml

struct HiddenInput: View, HTMLRepresentable {
    
    let name: String
    let value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    var body: some View {
        NeverView()
    }
    
    var htmlTag: Tag {
        Input()
            .class(name)
            .name(name)
            .type(.hidden)
            .value(value)
    }
    
    var children: [any View] = []
    
}
