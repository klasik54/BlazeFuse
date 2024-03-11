//
//  HelloView.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import Foundation

//final class ComponentsRegister {
//    
//    static let shared = ComponentsRegister()
//    
//    private init() {}
//    
//    var components: [String: any View & WithReactor] = [:]
//    
//    func register<T: View & WithReactor>(_ view: T) {
//        components[String(describing: T.self)] = view
//    }
//    
//}
//
//struct ReactorWrapperView<Content: View & WithReactor>: View & WithReactor {
//    
//    var content: Content
//    var reactor: Content.Actor
//    
//    init(content: Content, reactor: Content.Actor) {
//        self.content = content
//        self.reactor = reactor
//    }
//    
//    var body: some View {
//        content
//    }
//    
//}
//
//func get<T: View & WithReactor>(viewType: T.Type) async -> T {
//    var view = ComponentsRegister.shared.components[String(describing: viewType)] as! T
//    
//    let stateDate = Data()
//    let stateType = type(of: view.reactor).State
//    let state = try! JSONDecoder().decode(stateType, from: stateDate)
//    
//    let actionType = type(of: view.reactor).Action
//    let action = try! JSONDecoder().decode(actionType, from: Data())
//    view.reactor.currentState = await view.reactor.mutate(state: state, action: action)
//    
//    return view
//}
//
//
//protocol WithReactor {
//    
//    associatedtype Actor: Reactor
//    
//    var reactor: Actor { get set }
//    
//}
//
//
//protocol Reactor {
//    
//    associatedtype Action: Codable
//    associatedtype State: Codable
// 
//    var currentState: State { get set }
//    
//    func mutate(state: State, action: Action) async -> State
//    
//}
//
//struct Xx: WithReactor, View {
//    
//    var reactor = HelloViewModel()
//    
//    var body: some View {
//        Text("Hello")
//    }
//    
//}
//
//
//final class HelloViewModel: Reactor {
//
//    var currentState: State = State()
//    
//    enum Action: Codable {
//        
//        case increment
//        case decrement
//        
//    }
//    
//    struct State: Codable {
//        
//        var count: Int = 0
//        
//    }
//    
//    
//    func mutate(state: State, action: Action) async -> State {
//        var state = state
//        switch action {
//        case .increment:
//            state.count += 1
//
//        case .decrement:
//            state.count -= 1
//        }
//        
//        return state
//    }
//    
//}
//
//struct NewStateView: View, WithReactor {
//    
//    var reactor = HelloViewModel()
//    
//    var body: some View {
//        Text(reactor.currentState.count.description)
//        
//        ReactiveButton(reactor: reactor, action: .increment) {
//            Text("Hello")
//        }
//    }
//    
//}


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
        StatefulViewWrapper(
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

//struct ComponentData<State: Codable>: Codable {
//    
//    let componentId: String
//    let state: State
//    
//}

struct UpdateComponentRequest<T: Component>: Decodable {
    
    let id: String
    let state: T.State
    let action: T.Action
    
}

struct UpdateComponentRawRequest: Decodable {
    
    let id: String
    let state: String
    let action: String
    
}

class MyReactiveView: NSObject, Component  {
    
    
    enum Action: Codable {
        
        case increment
        case decrement
        case incrementBy(Int)
        
    }
    
    
    struct State: Codable {
        
        var count: Int
        
    }
    
    func onMount() -> State {
        State(count: 1)
    }
    
    var currentState: State = State(count: 1)
    
    func mutate(state: State, action: Action) async -> State {
        var state = state
        
        switch action {
        case .increment:
            state.count += 1
            
        case .decrement:
            state.count -= 1
            
        case .incrementBy(let value):
            state.count += value
        }
        
        return state
    }
    
    
    func render(state: State) -> some View {
        Group {
            Text("Current count is: \(state.count)")
            
            PrimaryButton(onClick: Action.increment) {
                Text("Increment")
            }
            
            PrimaryButton(onClick: Action.decrement) {
                Text("Decrement")
            }
            
            PrimaryButton(onClick: Action.incrementBy(state.count)) {
                Text("Increment by \(state.count)")
            }
        }
    }
    
}

struct HelloView: View {
 
    var props: Props
    @State var state = Data()
    
    struct Props: Codable {}
    struct Data: Codable {
        var count: Int = 0
    }
    
    init(props: Props) {
        self.props = props
    }
    
    struct Example {
        
        let title: String
        let href: String
        
    }
    
    private let examples: [Example] = [
        Example(title: "Counter", href: "/counter"),
        Example(title: "Text", href: "/text"),
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("👋 Welcome in BlazeFuse!")
                .font(.largeTitle)
                .foregroundColor(.red500)
            
            Text("👀 Checkout these examples:")
                .font(.title2)
                .foregroundColor(.blue500)
            
            ForEach(examples) { example in
                Link(href: example.href, example.title)
                    .padding(10)
                    .backgoundColor(.red300)
                    .padding(10)
                    .backgoundColor(.red400)
            }
            
            VStack {
                ForEach(1...5) { i in
                    Text("List item: \(i)")
                        .foregroundColor(.blue100)
                        .padding(10)
                        .backgoundColor(.blue800)
                }
            }
            
            MyCustomView()
                .padding(20)
                .backgoundColor(.red500)
            
        }.padding(30)
    }
    
}

struct MyCustomView: View {
    
    var body: some View {
        VStack {
            ForEach(1...3) {
                MySecondCustomView(text: $0.description)
                    .padding(20)
                    .backgoundColor(.blue600)
            }
        }
    }
    
}

struct MySecondCustomView: View {
    
    let text: String
    
    var body: some View {
        HStack {
            Text("This is second custom view")
            
            Text(text)
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
