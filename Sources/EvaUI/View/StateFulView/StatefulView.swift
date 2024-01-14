//
//  StatefulView.swift
//
//
//  Created by Matúš Klasovitý on 13/01/2024.
//

import Foundation
import Hummingbird

protocol StatefulView: View {
    
    associatedtype Props: Codable
    associatedtype Data: Codable
    
    var props: Props { get }
    var state: Data { get set }
    
    init(props: Props)
    
}

extension StatefulView {
    
    var id: String {
        String(describing: Self.self)
    }
    
    var wrapper: some View {
        let viewData = StatefulViewDataWrapper<Self>(
            id: id,
            props: props,
            state: state
        )
        
        var json: String {
            #warning("TODO: Remove force unwrap")
            let data = try! JSONEncoder().encode(viewData)
            
            return String(data: data, encoding: .utf8)!.replacingOccurrences(of: #"""#, with: #"&quot;"#)
        }
        
        return StatefulViewWrapper(id: id, jsonData: json) {
            body
        }
    }
    
}

func findView(by id: String, from view: some View) -> (any View)? {
    if let identifiableView = view as? any Identifiable<String>, identifiableView.id == id {
        return view
    } else if let taggableView = view as? Tagable {
        for view in taggableView.children {
            if let foundView = findView(by: id, from: view) {
                return foundView
            }
        }
        
        return nil
    } else {
        return findView(by: id, from: view.body)
    }
}
