//
//  StatefulViewRepository.swift
//  
//
//  Created by Matúš Klasovitý on 14/01/2024.
//

import Foundation

final class StatefulViewRepository {
    
    private var stateFullViews: [String: any StatefulView.Type] = [:]
    
    static let shared = StatefulViewRepository()
    
    func registerStateFullView(view: some StatefulView) {
        stateFullViews[view.id] = type(of: view)
    }
    
    func getStateFullView(by id: String, from data: Data) throws -> any StatefulView {
        let stateFullViewType = stateFullViews[id]!
        
        return try composeView(data: data, viewType: stateFullViewType)
    }

}

private extension StatefulViewRepository {
    
    func composeView<T: StatefulView>(data: Data, viewType: T.Type) throws -> T {
        let decoder = JSONDecoder()
        let dataWrapper = try decoder.decode(StatefulViewDataWrapper<T>.self, from: data)

        var view = T.init(props: dataWrapper.props)
        view.state = dataWrapper.state
        
        return view
    }
    
}
