//
//  ComponentType.swift
//  
//
//  Created by Matúš Klasovitý on 11/03/2024.
//

import Foundation

typealias Component = ComponentType & NSObject

protocol ComponentType: NSObject, View {
    
    associatedtype Props: Codable
    associatedtype State: Codable
    associatedtype Action: Codable
    associatedtype Content: View
    
    var props: Props { get set }
    
    func onMount(props: Props) -> State
    
    func mutate(state: State, action: Action) async -> State
    
    @ViewBuilder
    func render(props: Props, state: State) -> Content
    
}

extension ComponentType {
    
    init(file: String = #file, line: Int = #line, props: Props) {
        self.init()
        self.props = props
    }
    
    var body: some View {
        render(props: props, state: onMount(props: props))
    }
    
    var id: String {
        String(describing: Self.self)
    }
    
    @ViewBuilder
    func wrapper(state: State) -> some View {
        ComponentWrapper(
            id: id,
            jsonState: makeJSONString(from: stateData(state: state)),
            jsonProps: makeJSONString(from: propsData)
        ) {
            render(props: props, state: state)
        }
    }
    
    func stateData(state: State) -> Data {
        try! JSONEncoder().encode(state)
    }
    
    
    private var propsData: Data {
        try! JSONEncoder().encode(props)
    }
    
    private func makeJSONString(from data: Data) -> String {
        String(data: data, encoding: .utf8)!.replacingOccurrences(of: #"""#, with: #"&quot;"#)
    }

}
