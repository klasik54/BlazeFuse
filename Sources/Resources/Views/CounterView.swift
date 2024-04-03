//
//  CounterView.swift
//
//
//  Created by Matúš Klasovitý on 15/01/2024.
//

import Foundation

struct SayHelloEvent: Event {}

struct FooEvent: Event {
    
    let count: Int
    
}

final class CounterView: Component<CounterView.Props> {
    
    enum Action: Codable {
        
        case increment
        case decrement
        case incrementBy(Int)
        
    }
    
    struct Props: Codable {}
    
    struct State: Codable {
        
        var count: Int
        var helloText: String? = nil
        
    }
    
    func onMount(props: Props) -> State {
        State(count: 12)
    }
    
    func mutate(props: Props, state: State, action: Action) async -> State {
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
    
    func registerListeners() -> [EventListenerType] {
        [
            EventListener(for: FooEvent.self, listenerFunction: foo),
            EventListener(for: SayHelloEvent.self, listenerFunction: sayHello),
        ]
    }
    
    // @On(Event: SayHelloEvent.self)
    func sayHello(event: SayHelloEvent, state: State) async -> State {
        var state = state
        state.helloText = "Hello from child!"

        return state
    }
    
    // @On(Event: FooEvent.self)
    func foo(event: FooEvent, state: State) async -> State {
        var state = state
        state.count = event.count
        
        return state
    }
    
    func render(props: Props, state: State) -> some View {
        VStack {
            Text("Counter view")
                .font(.extraLargeTitle2)
                .padding(20)
                .backgoundColor(.red300)
                .padding(20)
                .backgoundColor(.red400)

            Text("🧮 Count: \(state.count.description)")
                .font(.title2)
                .foregroundColor(.blue600)
           
            HStack {
                Button(onClick: .trigger(Action.decrement)) {
                    Text("Decrement")
                }
                
                Button(onClick: .trigger(Action.increment)) {
                    Text("Increment")
                }
                
                Button(onClick: .trigger(Action.incrementBy(state.count))) {
                    Text("Increment by: \(state.count)")
                }
            }
                
            if let helloText = state.helloText {
                Text("Parent said: \(helloText)")
            }
                

            if state.count > 10 {
                Text("🎉 Count is greater than 10")
                    .font(.largeTitle)
                    .foregroundColor(.blue600)
            }
            
            Group {
                Text("Inner counter")
                
                CounterMultiplier(props: .init(parentCount: state.count))
                
                CounterMultiplier(props: .init(parentCount: state.count * 2))
                
                Receiver(props: .init())
            }
        }
        .padding(30)
    }
    
}

final class CounterMultiplier: Component<CounterMultiplier.Props> {
    
    struct Props: Codable {
        
        let parentCount: Int
        
    }
    
    enum Action: Codable {
        
        case increment
        case decrement
        case multiply
        case reset
        
    }
    
    struct State: Codable {
        
        let parentCount: Int
        var count: Int
        
    }
    
    func onMount(props: Props) -> State {
        return State(parentCount: props.parentCount, count: 31)
    }
    
    func mutate(props: Props, state: State, action: Action) async -> State {
        var state = state
        
        switch action {
        case .multiply:
            state.count *= props.parentCount
            
        case .increment:
            state.count += 1
            
        case .decrement:
            state.count -= 1

        case .reset:
            state.count = 0
        }
        
        return state
    }
    
    func render(props: Props, state: State) -> some View {
        VStack {
            Text("🧮 Count: \(state.count.description)")
                .font(.title2)
                .foregroundColor(.red600)
            
            Text("Parent Count: \(props.parentCount)")
           
            HStack {
                Button(onClick: .trigger(Action.multiply)) {
                    Text("Multiple by: \(props.parentCount)")
                }
                
                Button(onClick: .dispatch(SayHelloEvent())) {
                    Text("Say hello to parent")
                }
                
                Button(onClick: .dispatch(FooEvent(count: state.count))) {
                    Text("Set parent count to: \(state.count)")
                }
                
                Button(onClick: .trigger(Action.reset)) {
                    Text("Reset counter")
                }
                
                Button(onClick: .trigger(Action.increment)) {
                    Text("Increment")
                }
                
                Button(onClick: .trigger(Action.decrement)) {
                    Text("Decrement")
                }
            }
        }.padding(30)
    }

}


final class Receiver: Component<Receiver.Props> {
    
    enum Action: Codable {
        
       case action
        
    }
    
    struct Props: Codable {}
    
    struct State: Codable {
        
        var count: Int
        
    }
    
    func registerListeners() -> [EventListenerType] {
        [
            EventListener(for: FooEvent.self, listenerFunction: onCountChange)
        ]
    }
    
    func onCountChange(event: FooEvent, state: State) -> State {
        var state = state
        state.count = event.count
        
        return state
    }
    
    
    func onMount(props: Props) -> State {
        State(count: 0)
    }
    
    func mutate(props: Props, state: State, action: Action) async -> State {
        return state
    }
    
    func render(props: Props, state: State) -> some View {
        HStack {
            Text("I have this count: \(state.count)")
        }
    }

}
