//
//  HelloView.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import Foundation

struct HelloView: View {
 
    var props: Props
    // @State var state = Data()
    
    struct Props: Codable {}
    struct Data: Codable {
        var count: Int = 0
    }
    
    init(props: Props) {
        self.props = props
    }
    
    struct Example {
        
        let title: String
        let href: String
        
    }
    
    private let examples: [Example] = [
        Example(title: "Counter", href: "/counter"),
        Example(title: "Text", href: "/text"),
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("👋 Welcome in BlazeFuse!")
                .font(.largeTitle)
                .foregroundColor(.red500)
            
            Text("👀 Checkout these examples:")
                .font(.title2)
                .foregroundColor(.blue500)
            
            ForEach(examples) { example in
                Link(href: example.href, example.title)
                    .padding(10)
                    .backgoundColor(.red300)
                    .padding(10)
                    .backgoundColor(.red400)
            }
            
            VStack {
                ForEach(1...5) { i in
                    Text("List item: \(i)")
                        .foregroundColor(.blue100)
                        .padding(10)
                        .backgoundColor(.blue800)
                }
            }
            
            MyCustomView()
                .padding(20)
                .backgoundColor(.red500)
            
        }.padding(30)
    }
    
}

struct MyCustomView: View {
    
    var body: some View {
        VStack {
            ForEach(1...3) {
                MySecondCustomView(text: $0.description)
                    .padding(20)
                    .backgoundColor(.blue600)
            }
        }
    }
    
}

struct MySecondCustomView: View {
    
    let text: String
    
    var body: some View {
        HStack {
            Text("This is second custom view")
            
            Text(text)
        }
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
