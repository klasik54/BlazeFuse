//
//  ChangeStateRequest.swift
//
//
//  Created by Matúš Klasovitý on 14/01/2024.
//

import Foundation

struct ChangeStateRequest: Decodable {
    
    let data: String
    
    struct JSONData: Decodable {
        
        let id: String

    }
    
}
