//
//  Env.swift
//  
//
//  Created by Matúš Klasovitý on 03/01/2024.
//

import Foundation

let env = Env()

final class Env {
    
    private var storage: [String: String] = [:]
    
    init() {
        self.loadEnvValues()
    }
    
    private func loadEnvValues() {
        let envPath = FileManager.default.currentDirectoryPath + "/.env"
        let envFile = try! String(contentsOfFile: envPath)
        let envLines = envFile.split(separator: "\n")
        for line in envLines {
            if line.starts(with: "#") {
                continue
            }
            let lineParts = line.split(separator: "=")
            let key = String(lineParts[0])
            let value = if lineParts.count == 1 {
                ""
            } else {
                String(lineParts[1])
            }
            self.storage[key] = value
        }
    }

    func callAsFunction<T: InitializableFromString>(_ key: String, defaultValue: T) -> T {
        T(self.storage[key] ?? "-") ?? defaultValue
    }
    
}

protocol InitializableFromString {
    
    init?(_ description: String)
    
}

extension Int: InitializableFromString {}
extension Double: InitializableFromString {}
extension Float: InitializableFromString {}
extension String: InitializableFromString {}
extension Bool: InitializableFromString {}
