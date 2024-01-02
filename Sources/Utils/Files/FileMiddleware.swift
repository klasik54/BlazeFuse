//
//  File.swift
//  
//
//  Created by Matúš Klasovitý on 02/01/2024.
//

import Foundation
import Hummingbird

final class FileMiddleware: HBAsyncMiddleware {
    
    private let publicDirectory: String = FileManager.default.currentDirectoryPath + "/Public/"
    private let defaultFile: String? = nil
    
    func apply(to request: HBRequest, next: HBResponder) async throws -> HBResponse {
        // make a copy of the percent-decoded path
        guard var path = request.uri.path.removingPercentEncoding else {
            throw HBHTTPError(.badRequest)
        }

        // path must be relative.
        path = path.removeLeadingSlashes()

        // protect against relative paths
        guard !path.contains("../") else {
            throw HBHTTPError(.forbidden)
        }

        // create absolute path
        let absPath = self.publicDirectory + path

        // check if path exists and whether it is a directory
        var isDir: ObjCBool = false
        guard FileManager.default.fileExists(atPath: absPath, isDirectory: &isDir) else {
            return try await next.respond(to: request)
        }
        
        if isDir.boolValue {
            guard absPath.hasSuffix("/") else {
                return try await next.respond(to: request)
            }
        }
        
        let file = try Data(contentsOf: URL(filePath: absPath))
        
        let response = HBResponse(
            status: .accepted,
            body: .byteBuffer(ByteBuffer(data: file))
        )
        
        return response
    }
    
}

fileprivate extension String {

    func removeLeadingSlashes() -> String {
        var newPath = self
        while newPath.hasPrefix("/") {
            newPath.removeFirst()
        }
        return newPath
    }
    
}
