//
//  TextField.swift
//
//
//  Created by Matúš Klasovitý on 03/04/2024.
//

import Foundation
import SwiftHtml

//@propertyWrapper
//struct Binding<Value> {
//    
//    private let get: () -> Value
//    private let set: (Value) -> Void
//    
//    var wrappedValue: Value {
//        get { get() }
//        set { set(newValue) }
//    }
//    
//    init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
//        self.get = get
//        self.set = set
//    }
//    
//}

struct TextField: View, HTMLRepresentable {
    
    private let placeholder: String
    private let name: String
    private let value: String?
    
    init(_ placeholder: String, name: String) {
        self.placeholder = placeholder
        self.name = name
        self.value = nil
    }
    
//    init(_ placeholder: String, value: String, onChange: Handler) {
//        self.placeholder = placeholder
//        self.name = nil
//        self.value = value
//        self.handler = onChange
//    }
    
    init<State: StateType>(_ placeholder: String, text: FooBar<State, String>) {
        self.placeholder = placeholder
        self.name = text.keyPath.debugDescription // NSExpression(forKeyPath: text.keyPath).keyPath
        self.value = text.value
    }
    
    var body: some View {
        NeverView()
    }
    
//    var encodedAction: String {
//        switch handler {
//        case .trigger(let action):
//            let data = try! JSONEncoder().encode(action)
//            return String(data: data, encoding: .utf8)!.replacingOccurrences(of: #"""#, with: #"&quot;"#)
//
//        case .dispatch(let event):
//            let data = try! JSONEncoder().encode(event)
//            return String(data: data, encoding: .utf8)!.replacingOccurrences(of: #"""#, with: #"&quot;"#)
//            
//        case .none:
//            return ""
//        }
//    }
    
    var htmlTag: SwiftHtml.Tag {
        var input = Input()
            .attribute("placeholder", placeholder)
            .attribute("hx-post", "/fuse")
            // .attribute("hx-trigger", "keyup changed delay:500ms")
            // .attribute("hx-target", "closest [data-node-type='component']")
            .attribute("name", name)
        
        if let value {
            input
                .attribute("hx-trigger", "keyup changed delay:500ms")
                .attribute("hx-target", "closest [data-node-type='component']")
                .attribute("value", value)
        }
        
//        if let name {
//            input.attribute("name", name)
//        }
//        
//        if let value {
//            input.attribute("value", value)
//        }
//        if let handler {
//            input
//                // .attribute("hx-post", "/fuse")
//                .attribute("hx-trigger", "keyup changed delay:500ms")
//                .attribute("hx-target", "closest [data-node-type='component']")
//            
//            switch handler {
//            case .trigger:
//                input.attribute("data-action-data", encodedAction)
//
//            case .dispatch(let event):
//                input
//                    .attribute("data-node-type", "dispatcher")
//                    .attribute("data-event-data", encodedAction)
//                    .attribute("data-event-name", type(of: event).identifier)
//            }
//            
        // }
        return input
    }
    
    var children: [any View] {
        []
    }
    
}
