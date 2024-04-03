//
//  Event.swift
//  
//
//  Created by Matúš Klasovitý on 28/03/2024.
//

import Foundation

protocol Event: Codable, Hashable {
    
    static var identifier: String { get }
    
}

extension Event {
        
    static var identifier: String {
        String(describing: self)
    }

}
