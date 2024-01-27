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
            }
            
            if state.count > 10 {
                Text("🎉 Count is greater than 10")
                    .font(.largeTitle)
                    .foregroundColor(.blue600)
            }
        }.padding(30)
    }
    
}
