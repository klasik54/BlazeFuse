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
    
//    init(file: String = #file, line: Int = #line) {
//        print(file, line)
//        self.init()
//    }
    
    var body: some View {
        render(state: onMount())
    }
    
    var id: String {
        String(describing: Self.self)
    }
    
    @ViewBuilder
    func wrapper() -> some View {
        ComponentWrapper(
            id: id,
            jsonData: String(data: jsonData, encoding: .utf8)!.replacingOccurrences(of: #"""#, with: #"&quot;"#)
        ) {
            render(state: currentState)
        }
    }
    
    private var jsonData: Data {
        try! JSONEncoder().encode(currentState)
    }

}
