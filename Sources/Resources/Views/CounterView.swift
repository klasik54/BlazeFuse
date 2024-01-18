//
//  CounterView.swift
//
//
//  Created by Matúš Klasovitý on 15/01/2024.
//

import Foundation

struct CounterView: StatefulView {
 
    var props: Props
    @State var state = Data()
    
    struct Props: Codable {}
    struct Data: Codable {
        var count: Int = 0
    }
    
    init(props: Props) {
        self.props = props
    }
    
    var tenTimesMore: Int {
        state.count * 10
    }
    
    var body: some View {
        Text("Counter view")
//            .font(.extraLargeTitle2)
//            .backgoundColor(.green700)
//            .foregroundColor(.red700)
//            .padding(30)
//            .backgoundColor(.blue700)

        Text(state.count.description)
        Text("10 times more is \(tenTimesMore)")
       
        Button {
            print("Decrementing \(state.count)")
            state.count -= 1
            print("Finished decrementing \(state.count)")
        } label: {
            Text("Decrement")
        }
        
        Button {
            print("Incrementing \(state.count)")
            state.count += 1
            print("Finished incrementing \(state.count)")
        } label: {
            Text("Increment")
        }
        
        if state.count > 10 {
            Text("Count is greater than 10")
        }
    }
    
}
