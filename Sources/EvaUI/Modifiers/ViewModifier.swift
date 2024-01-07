//
//  ViewModifier.swift
//
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import SwiftHtml

protocol ViewModifier {
    
    var className: String { get }
    var tag: Tag? { get }
    
}

extension ViewModifier {
    
    var tag: Tag? {
        nil
    }
    
}
