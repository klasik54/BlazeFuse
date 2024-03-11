//
//  Component.swift
//  
//
//  Created by Matúš Klasovitý on 11/03/2024.
//

import Foundation

protocol Component: NSObject, View {
    
    associatedtype State: Codable
    associatedtype Action: Codable
    associatedtype Content: View
    
    var currentState: State { get set }
    
    
    func onMount() -> State
    
    func mutate(state: State, action: Action) async -> State
    
    @ViewBuilder
    func render(state: State) -> Content
    
}

extension Component {
    
    var body: some View {
        render(state: onMount())
    }
    
    @ViewBuilder
    func wrapper() -> some View {
        ComponentWrapper(
            id: String(describing: Self.self),
            jsonData: String(data: jsonData, encoding: .utf8)!.replacingOccurrences(of: #"""#, with: #"&quot;"#)
        ) {
            render(state: currentState)
        }
    }
    
    private var jsonData: Data {
        try! JSONEncoder().encode(currentState)
    }

}
