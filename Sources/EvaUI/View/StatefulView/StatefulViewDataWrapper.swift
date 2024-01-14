//
//  StatefulViewDataWrapper.swift
//
//
//  Created by Matúš Klasovitý on 14/01/2024.
//

import Foundation

struct StatefulViewDataWrapper<T: StatefulView>: Codable {
    
    let id: String
    let props: T.Props
    let state: T.Data
    
}
