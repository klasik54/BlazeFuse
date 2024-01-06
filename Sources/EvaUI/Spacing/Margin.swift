//
//  Margin.swift
//
//
//  Created by Matúš Klasovitý on 06/01/2024.
//

import Foundation
import SwiftHtml

extension Tag {
    
    func margin(_ corners: Corner = .all, _ spacing: Int = 8) -> Tag {
        self.class(add: "m\(corners.rawValue)-\(spacing)")
    }

}
