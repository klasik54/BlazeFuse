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
            print("Decrementing \(state.count)")
            state.count -= 1
            print("Finished decrementing \(state.count)")
        } label: {
            Text("Decrement")
        }
        
        Button {
            print("Incrementing \(state.count)")
            state.count += 1
            print("Finished incrementing \(state.count)")
        } label: {
            Text("Increment")
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
