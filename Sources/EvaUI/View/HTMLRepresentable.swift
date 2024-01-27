//
//  HTMLRepresentable.swift
//
//
//  Created by Matúš Klasovitý on 20/01/2024.
//

import SwiftHtml

protocol HTMLRepresentable {
    
    var htmlTag: Tag { get }
    var children: [any View] { get }
    
}
