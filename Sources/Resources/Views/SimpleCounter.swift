//
//  SimpleCounter.swift
//  
//
//  Created by Matúš Klasovitý on 05/08/2024.
//

import Foundation

final class SimpleCounterView: Component<SimpleCounterView.Props> {
   
    struct Props: Codable {}
    
    enum Action: Codable {
        
        case increment
        case decrement
        
    }
    
    struct State: StateType {
        
        var count: Int
        
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
                Button(onClick: .trigger(Action.decrement)) {
                    Text("Decrement")
                }
                
                Button(onClick: .trigger(Action.increment)) {
                    Text("Increment")
                }
            }
        }
    }
    
}
