//
//  InputsView.swift
//
//
//  Created by Matúš Klasovitý on 03/04/2024.
//

import Foundation

struct User: Codable {
    
    var firstName: String
    var lastName: String
    var age: String
    
}

final class InputsView: Component<InputsView.Props> {

    struct Props: Codable {}
    
    struct State: StateType {
        
        var user: User
        var note: String
        
    }
    
    enum Action: Codable {
        
        case updateFirstName(String)
        case updateLastName(String)
        case updateHello(String)
        
    }
    
    func onMount(props: Props) -> State {
        State(user: User(firstName: "", lastName: "", age: "12"), note: "")
    }
    
    func mutate(props: Props, state: State, action: Action) async -> State {
        return state
    }
    
    func render(props: Props, state: State) -> some View {
        VStack {
            Text("👋 Hello: \(state.user.firstName) \(state.user.lastName)")
            TextField("Name", text: state.bind(\.user.firstName))
            TextField("Last name", text: state.bind(\.user.lastName))
            TextChild(text: state.bind(\.user.age))
            TextEditor("Write your note...", text: state.bind(\.note))
            
            Text("You are: \(state.user.age) years old :)")
            Text("Your note: \(state.note)")
        }
    }
    
}

struct TextChild: View {
    
    @Binding var text: String
    
    var body: some View {
        TextField("Age", text: $text)
    }
    
}
