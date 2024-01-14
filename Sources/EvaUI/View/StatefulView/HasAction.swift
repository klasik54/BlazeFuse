//
//  HasAction.swift
//
//
//  Created by Matúš Klasovitý on 14/01/2024.
//

import Foundation

protocol HasAction {
    
    var action: () -> Void { get }
    
}
