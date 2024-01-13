//
//  View.swift
//  
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation
import Hummingbird

protocol View: HBResponseGenerator {
    
    associatedtype Body: View
    
    @ViewBuilder var body: Self.Body { get }
    
}

extension View {
    
    public func response(from request: HBRequest) throws -> HBResponse {
        let viewRenderer = ViewRenderer()
        
        let html = viewRenderer.render(self)
        
        
        return HBResponse(
            status: .ok,
            headers: [
                "Content-Type": "text/html"
            ],
            body: .byteBuffer(ByteBuffer(string: html))
        )
    }
    
}

extension Never: View {
    
    init() {
        fatalError()
    }
    
    var body: some View {
        fatalError()
    }
    
}
