//
//  AuthController.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import Foundation
import Hummingbird

final class AuthController {
    
    static func index(req: LoginRequest) -> some View {
        return HelloView(
            title: "Welcom \(req.username)"
        )
    }
    
    static func register(req: HBRequest) -> some View {
        return RegisterView()
    }
    
}
