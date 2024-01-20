//
//  ModifiedContent.swift
//  
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import Hummingbird

protocol AnyModifiedContent {
    
    var anyModifier: Any { get }
    
}

struct ModifiedContent<Content, Modifier>: AnyModifiedContent {
    
    var anyModifier: Any { modifier }
    
    let content: Content
    let modifier: Modifier
    
}

extension ModifiedContent: HBResponseGenerator where Content: View, Modifier: ViewModifier {
    
    func response(from request: HBRequest) throws -> HBResponse {
        return try content.response(from: request)
    }

}

extension ModifiedContent: View where Content: View, Modifier: ViewModifier {
    
    var body: some View {
        content
    }
    
}
