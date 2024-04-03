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
    
    func mutate(props: Props, state: State, action: Action) async -> State
    
    func registerListeners() -> [EventListenerType]
    
    @ViewBuilder
    func render(props: Props, state: State) -> Content
    
    func getCurrentProps() -> Props
    func getId() -> String
    
    init(line: Int, file: String, props: Props)
    init(id: String, props: Props)
    
}

extension ComponentType {
    
    var body: some View {
        render(props: getCurrentProps(), state: onMount(props: getCurrentProps()))
    }
    
    @ViewBuilder
    func wrapper(state: State) -> some View {
        ComponentWrapper(
            id: getId(),
            name: String(describing: Self.self),
            jsonState: makeJSONString(from: stateData(state: state)),
            jsonProps: makeJSONString(from: propsData(props: getCurrentProps())),
            listeners: registerListeners()
        ) {
            render(props: getCurrentProps(), state: state)
        }
    }
    
    func stateData(state: State) -> Data {
        try! JSONEncoder().encode(state)
    }
    
    func registerListeners() -> [EventListenerType] {
        []
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
    var id: String
    
    required init(line: Int = #line, file: String = #file, props: Props) {
        self.props = props
        self.id = Self.generateId(line: line, file: file)
    }
    
    required init(id: String, props: Props) {
        self.props = props
        self.id = id
    }
    
    func getCurrentProps() -> Props {
        props
    }
    
    func getId() -> String {
        id
    }
    
    private static func generateId(line: Int, file: String) -> String {
        var hasher = Hasher()
        hasher.combine(file)
        hasher.combine(line)
        
        return String(hasher.finalize())
    }

}
