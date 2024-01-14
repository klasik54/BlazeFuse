//
//  File.swift
//  
//
//  Created by Matúš Klasovitý on 13/01/2024.
//

import Foundation
import Hummingbird

func getAnySomeView() -> any View {
    EmptyView()
}

struct DataWrapper<T: StateFullView>: Codable {
    
    let id: String
    let props: T.Props
    let state: T.Data
    
}

protocol StateFullView: View {
    
    associatedtype Props: Codable
    associatedtype Data: Codable
    
    var props: Props { get }
    var state: Data { get set }
    
    init(props: Props)
    
}

extension StateFullView {
    
    var id: String {
        String(describing: Self.self)
    }
    
    var wrapper: some View {
        let viewData = DataWrapper<Self>(
            id: id,
            props: props,
            state: state
        )
        
        var json: String {
//            let data = try! JSONEncoder().encode(viewData)
//            let jsonData = try! JSONSerialization.data(withJSONObject: data)
//            return String(data: jsonData, encoding: .utf8)!
            let data = try! JSONEncoder().encode(viewData)
            
            let result = String(data: data, encoding: .utf8)!.replacingOccurrences(of: #"""#, with: #"&quot;"#)
            
//            print(result)
            
            return result //#"\#()"# //result
        }
        
        return ViewWrapper(id: id, jsonData: json) {
            body
        }
    }
    
}


final class StateFullViewRepository {
    
    private var stateFullViews: [String: any StateFullView.Type] = [:]
    
    static let shared = StateFullViewRepository()
    
    func registerStateFullView(view: some StateFullView) {
        stateFullViews[view.id] = type(of: view) 
    }
    
    func getStateFullView(by id: String, from data: Data) -> any StateFullView {
        let stateFullViewType = stateFullViews[id]!
        
        return decode(data: data, bar: stateFullViewType)
    }

}

private extension StateFullViewRepository {
    
    func decode<T: StateFullView>(data: Data, bar: T.Type) -> T {
        let decoder = JSONDecoder()
        let dataWrapper = try! decoder.decode(DataWrapper<T>.self, from: data)

        var bar = T.init(props: dataWrapper.props)
        bar.state = dataWrapper.state
        
        return bar
    }
    
}


func findView(by id: String, from view: some View) -> ((any View)?) {
    if let identifiableView = view as? any Identifiable<String>, identifiableView.id == id {
        print("Returning: \(type(of: view))")
        return view
    } else if let taggableView = view as? Tagable {
        return taggableView.children.first(where: { findView(by: id, from: $0) != nil  })
    } else {
        return findView(by: id, from: view.body)
    }
}
