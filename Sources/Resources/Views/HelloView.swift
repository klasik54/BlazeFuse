//
//  HelloView.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import SwiftHtml

struct HelloView: StateFullView {
 
    var props: Props
    @State var state = Data()
    
    struct Props: Codable {
        
        let title: String
        
    }
    struct Data: Codable {
        var count: Int = 0
    }
    
    init(props: Props) {
        self.props = props
    }
    
    var body: some View {
        Text(props.title)
            .font(.extraLargeTitle2)
            .backgoundColor(.green700)
            .foregroundColor(.red700)
            .padding(30)
            .backgoundColor(.blue700)
        
        Text(props.title)
            .fontFamily(.serif)
            .backgoundColor(.blue300)
            .foregroundColor(.red700)
            .padding(30)
            .backgoundColor(.yellow700)
        
        Text(state.count.description)
        

        Button {
            print("Decrementing")
            state.count -= 1
        } label: {
            Text("Decrement")
        }
        
        Button {
            print("Incrementing")
            state.count += 1
            
        } label: {
            Text("Increment")
        }
    }
    
}

import Foundation

struct ViewWrapper<Content: View>: View, Tagable {
    
    let id: String
    let view: Content
    let jsonData: String
    
    init(
        id: String,
        jsonData: String,
        @ViewBuilder view: () -> Content
    ) {
        self.id = id
        self.jsonData = jsonData
        self.view = view()
    }
    
    var body: some View {
        self
    }
    
    var tag: Tag {
        Div {
            Input()
                .name("data")
                .type(.hidden)
                .value(jsonData)

            ViewRenderer().tagFrom(view: view)
        }
        .id(id)
        .class("component")
    }
    
}

struct RadiusSize {
    
    static let sm = RadiusSize(className: "sm")
    static let md = RadiusSize(className: "md")
    static let lg = RadiusSize(className: "lg")
    static let xl = RadiusSize(className: "xl")
    static let full = RadiusSize(className: "full")
    
    let className: String
    
}
