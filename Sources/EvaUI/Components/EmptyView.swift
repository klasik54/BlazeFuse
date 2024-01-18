//
//  EmptyView.swift
//
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import SwiftHtml

struct EmptyView: View, HTMLRepresentable {
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] {
        []
    }
    
    var parentTag: Tag? { Div() }
    
//    var tag: Tag {
//        Div()
//            .class(add: "none")
//    }
    
}
