//
//  Binding.swift
//  
//
//  Created by Matúš Klasovitý on 04/04/2024.
//

import Foundation

@propertyWrapper
struct Binding<Value> {
    
    var wrappedValue: Value
    let name: String
    
    init(name: String, value: Value) {
        self.wrappedValue = value
        self.name = name
    }
    
    var projectedValue: Binding<Value> {
        Binding(name: name, value: wrappedValue)
    }
    
}
