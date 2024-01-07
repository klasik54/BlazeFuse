//
//  BackgroundColorModifier.swift
//
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation

struct BackgroundColorModifier: ViewModifier {
    
    let color: Color
    var className: String {
        "bg-\(color.className)"
    }
    
}

extension View {
    
    func backgoundColor(_ color: Color) -> some View {
        return ModifiedContent(content: self, modifier: BackgroundColorModifier(color: color))
    }
    
}
