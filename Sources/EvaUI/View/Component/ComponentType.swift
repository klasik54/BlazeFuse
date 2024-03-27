//
//  ComponentType.swift
//  
//
//  Created by Matúš Klasovitý on 11/03/2024.
//

import Foundation

typealias Component<Props: Codable> = ComponentType & PropsHolder<Props>

protocol ComponentType: View {
    
    associatedtype Props: Codable
    associatedtype State: Codable
    associatedtype Action: Codable
    associatedtype Content: View
    
    func onMount(props: Props) -> State
    
    func mutate(state: State, action: Action) async -> State
    
    @ViewBuilder
    func render(props: Props, state: State) -> Content
    
    func getCurrentProps() -> Props
    
    init(props: Props)
    
}

extension ComponentType {
    
    var body: some View {
        render(props: getCurrentProps(), state: onMount(props: getCurrentProps()))
    }
    
    var id: String {
        String(describing: Self.self)
    }
    
    @ViewBuilder
    func wrapper(state: State) -> some View {
        ComponentWrapper(
            id: id,
            jsonState: makeJSONString(from: stateData(state: state)),
            jsonProps: makeJSONString(from: propsData(props: getCurrentProps()))
        ) {
            render(props: getCurrentProps(), state: state)
        }
    }
    
    func stateData(state: State) -> Data {
        try! JSONEncoder().encode(state)
    }
    
    
    private func propsData(props: Props) -> Data {
        try! JSONEncoder().encode(props)
    }
    
    private func makeJSONString(from data: Data) -> String {
        String(data: data, encoding: .utf8)!.replacingOccurrences(of: #"""#, with: #"&quot;"#)
    }

}

class PropsHolder<Props: Codable> {
    
    var props: Props
    
    required init(props: Props) {
        self.props = props
    }
    
    func getCurrentProps() -> Props {
        props
    }

}
