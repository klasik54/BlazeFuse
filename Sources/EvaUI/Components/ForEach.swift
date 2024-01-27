//
//  ForEach.swift
//
//
//  Created by Matúš Klasovitý on 18/01/2024.
//

import SwiftHtml

struct ForEach<Content: View, Data: RandomAccessCollection>: View, HTMLRepresentable {
    
    let content: (Data.Element) -> Content
    let data: Data
    
    init(_ data: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.content = content
        self.data = data
    }
    
    var body: some View {
        NeverView()
    }
    
    var htmlTag: Tag = GroupTag()
    
    var children: [any View] {
        data.map { content($0) }
    }
    
}
