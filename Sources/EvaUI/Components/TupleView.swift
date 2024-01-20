//
//  TupleView.swift
//
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import SwiftHtml

struct TupleView<T>: View, HTMLRepresentable {
    
    var value: T
    
    private var values: [Mirror.Child] {
        let mirror = Mirror(reflecting: value)
        
        return mirror.children.map { $0.self }
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] {
        values.compactMap { $0.value as? any View }
    }
    
    var parentTag: Tag { GroupTag() }
    
}
