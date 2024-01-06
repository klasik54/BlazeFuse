//
//  Padding.swift
//
//
//  Created by Matúš Klasovitý on 06/01/2024.
//

import Foundation
import SwiftHtml

extension Tag {
    
    func padding(_ corners: Corner = .all, _ spacing: Int = 8) -> Tag {
        self.class(add: "p\(corners.rawValue)-[\(spacing)px]")
    }
    
    func padding(_ spacing: Int = 8) -> Tag {
        self.padding(.all, spacing)
    }

}
