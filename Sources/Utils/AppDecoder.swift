//
//  AppDecoder.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import Hummingbird
import HummingbirdFoundation
import MultipartKit

struct AppDecoder: HBRequestDecoder {
    
    func decode<T>(_ type: T.Type, from request: HBRequest) throws -> T where T : Decodable {
        switch request.headers["content-type"].first {
        case "application/json", "application/json; charset=utf-8":
            return try JSONDecoder().decode(type, from: request)
            
        case "application/x-www-form-urlencoded":
            return try URLEncodedFormDecoder().decode(type, from: request)
            
        case let contentType where contentType?.contains("multipart/form-data") == true:
            guard let buffer = request.body.buffer,
                  let boundary = contentType?.split(separator: ";").first(where: { $0.contains("boundary") })?.split(separator: "=").last
            else {
                throw HBHTTPError(.badRequest)
            }
            
            return try FormDataDecoder().decode(type, from: buffer, boundary: String(boundary))
        
        default:
            throw HBHTTPError(.badRequest)
        }
    }
    
}
