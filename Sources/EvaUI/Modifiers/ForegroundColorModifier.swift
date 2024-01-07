//
//  ForegroundColorModifier.swift
//
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation

struct ForegroundColorModifier: ViewModifier {
    
    let color: Color
    var className: String {
        "text-\(color.className)"
    }
    
}

extension View {
    
    func foregroundColor(_ color: Color) -> some View {
        return ModifiedContent(content: self, modifier: ForegroundColorModifier(color: color))
    }
    
}
