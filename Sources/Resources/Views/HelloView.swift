//
//  HelloView.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import SwiftHtml

struct HelloView: View {
    
    let title: String
    
    
    var body: some View {
        Text(title)
            .font(.extraLargeTitle2)
            .backgoundColor(.green700)
            .foregroundColor(.red700)
            .padding(30)
            .backgoundColor(.blue700)
        
        Text(title)
            .fontFamily(.serif)
            .backgoundColor(.blue300)
            .foregroundColor(.red700)
            .padding(30)
            .backgoundColor(.yellow700)
        
        Text(#file)
        Text(#function)
        
        Button(file: "dsad", line: 23) {
            print("Hy ho")
        } label: {
            Text("Click me")
        }
        Button(file: "dsad", line: 23) {
            print("Hy ho")
        } label: {
            Text("Click me")
        }
        Button(file: "dsad", line: 23) {
            print("Hy ho")
        } label: {
            Text("Click me")
        }
        
        Button {
            print("Hy ho")
        } label: {
            Text("Click me")
        }
        
        Button {
            print("Hy ho")
        } label: {
            Text("Heheh me")
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
