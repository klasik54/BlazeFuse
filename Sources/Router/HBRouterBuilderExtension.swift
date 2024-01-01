//
//  HBRouterBuilderExtension.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import Hummingbird

extension HBRouterBuilder {
    
    func get<Output: HBResponseGenerator, Request: AppRequest>(_ path: String, options: HBRouterMethodOptions = [], use handler: @escaping (Request) async throws -> Output) {
        get(path, options: options) { hbRequest in
            let appRequest = try hbRequest.decode(as: Request.self)
            return try await handler(appRequest)
        }
    }
    
    func post<Output: HBResponseGenerator, Request: AppRequest>(_ path: String, options: HBRouterMethodOptions = [], use handler: @escaping (Request) async throws -> Output) {
        post(path, options: options) { hbRequest in
            let appRequest = try hbRequest.decode(as: Request.self)
            return try await handler(appRequest)
        }
    }
    
    func put<Output: HBResponseGenerator, Request: AppRequest>(_ path: String, options: HBRouterMethodOptions = [], use handler: @escaping (Request) async throws -> Output) {
        put(path, options: options) { hbRequest in
            let appRequest = try hbRequest.decode(as: Request.self)
            return try await handler(appRequest)
        }
    }
    
    func patch<Output: HBResponseGenerator, Request: AppRequest>(_ path: String, options: HBRouterMethodOptions = [], use handler: @escaping (Request) async throws -> Output) {
        patch(path, options: options) { hbRequest in
            let appRequest = try hbRequest.decode(as: Request.self)
            return try await handler(appRequest)
        }
    }
    
    func delete<Output: HBResponseGenerator, Request: AppRequest>(_ path: String, options: HBRouterMethodOptions = [], use handler: @escaping (Request) async throws -> Output) {
        delete(path, options: options) { hbRequest in
            let appRequest = try hbRequest.decode(as: Request.self)
            return try await handler(appRequest)
        }
    }
    
}
