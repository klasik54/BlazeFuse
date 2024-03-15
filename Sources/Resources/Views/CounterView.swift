//
//  CounterView.swift
//
//
//  Created by Matúš Klasovitý on 15/01/2024.
//

import Foundation

class CounterView: NSObject, Component  {
    
    enum Action: Codable {
        
        case increment
        case decrement
        case incrementBy(Int)
        
    }
    
    struct Props: Codable {}
    
    struct State: Codable {
        
        var count: Int
        
    }
    
    func onMount(props: Props) -> State {
        State(count: 1)
    }
    
    var currentState: State = State(count: 1)
    var props: Props = Props()
    
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
                Button(onClick: Action.decrement) {
                    Text("Decrement")
                }
                
                Button(onClick: Action.increment) {
                    Text("Increment")
                }
            }

            if state.count > 10 {
                Text("🎉 Count is greater than 10")
                    .font(.largeTitle)
                    .foregroundColor(.blue600)
            }
            
            Group {
                Text("Inner counter")
                
                Xx(props: .init(parentCount: state.count))
            }
        }.padding(30)
    }
    
}

final class Xx: NSObject, Component {
    
    struct Props: Codable {
        
        let parentCount: Int
        
    }
    
    enum Action: Codable {
        
        case increment
        case decrement
        case incrementBy(Int)
        
    }
    
    
    struct State: Codable {
        
        let parentCount: Int
        var count: Int
        
    }
    
    func onMount(props: Props) -> State {
        return State(parentCount: props.parentCount, count: 31)
    }
    
    var currentState: State = State(parentCount: 1, count: 1)
    var props: Props = Props(parentCount: -32)
    
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
    
    func render(props: Props, state: State) -> some View {
        VStack {
            Text("🧮 Count: \(state.count.description)")
                .font(.title2)
                .foregroundColor(.blue600)
            
            Text("Parent Count: \(props.parentCount)")
           
            HStack {
                Button(onClick: Action.decrement) {
                    Text("Decrement")
                }
                
                Button(onClick: Action.increment) {
                    Text("Increment")
                }
            }

            if state.count > 10 {
                Text("🎉 Count is greater than 10")
                    .font(.largeTitle)
                    .foregroundColor(.blue600)
            }
        }.padding(30)
    }
}
