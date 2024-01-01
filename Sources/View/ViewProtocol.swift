//
//  ViewProtocol.swift
//  
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import Hummingbird
import SwiftHtml

protocol View: HBResponseGenerator {
    
    @TagBuilder var body: Tag { get }
    
}

extension View {
    
    func response(from request: HBRequest) throws -> HBResponse {
        let document = Document(.html) {
            body
        }
        
        let html = DocumentRenderer().render(document)
        
        return HBResponse(
            status: .ok,
            headers: [
                "Content-Type": "text/html"
            ],
            body: .byteBuffer(ByteBuffer(string: html))
        )
    }
    
}
