//
//  State.swift
//  
//
//  Created by Matúš Klasovitý on 13/01/2024.
//

import Foundation

@propertyWrapper
struct State<Value> {
    
    private var value: Value
    
    var wrappedValue: Value {
        get { store.value }
        nonmutating set {
            store.value = newValue
        }
    }
    
    init(wrappedValue: Value) {
        self.value = wrappedValue
        self.store = StateStore(value: wrappedValue)
    }
    
    private let store: StateStore<Value>
    
}

private final class StateStore<Value> {
    
    var value: Value
    
    init(value: Value) {
        self.value = value
    }
    
}
