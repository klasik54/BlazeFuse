//
//  HelloView.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import Foundation

struct HelloView: StatefulView {
 
    var props: Props
    @State var state = Data()
    
    struct Props: Codable {}
    struct Data: Codable {
        var count: Int = 0
    }
    
    init(props: Props) {
        self.props = props
    }
    
    var body: some View {
        Text("Welcome!")
            .font(.extraLargeTitle2)
            .backgoundColor(.green700)
            .foregroundColor(.red700)
            .padding(30)
            .backgoundColor(.blue700)
        
        VStack {
            Text("Examples:")
                .font(.title2)
            
            List {
                Link(href: "/counter", "Counter")
            }
            .listStyle(.disc)
        }
        .padding(30)
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
