//
//  AppDecoder.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import Foundation
import Hummingbird

struct AppDecoder: HBRequestDecoder {
    
    func decode<T>(_ type: T.Type, from request: HBRequest) throws -> T where T : Decodable {
        let jsonDecoder = JSONDecoder()
        guard let body = request.body.buffer else {
            throw HBHTTPError(.badRequest)
        }
        

        return try jsonDecoder.decode(T.self, from: body)
    }
    
}
