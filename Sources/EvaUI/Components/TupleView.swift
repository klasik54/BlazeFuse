//
//  TupleView.swift
//
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import SwiftHtml

struct TupleView<T>: View, Tagable {
    
    var value: T
    
    private var values: [Mirror.Child] {
        let mirror = Mirror(reflecting: value)
        
        return mirror.children.map { $0.self }
    }
    
    var body: some View {
        EmptyView()
    }
    
    var tag: Tag {
        Div {
            for x in values {
                if let content = x.value as? any View {
                    ViewRenderer().tagFrom(view: content)
                }
            }
        }
    }
    
}
