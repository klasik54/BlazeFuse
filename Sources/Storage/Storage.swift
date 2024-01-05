//
//  Storage.swift
//
//
//  Created by Matúš Klasovitý on 03/01/2024.
//

import Foundation
import Hummingbird

final class Storage {
    
    /// Path to storage
    private let storagePath = FileManager.default.currentDirectoryPath + "/Storage/App/Public/"
    private let fileManager = FileManager.default
    
    /// Singleton
    static let shared = Storage()
    
    /// Private init
    private init() {}
    
    /// Save file to storage
    /// - Parameters:
    ///  - file: File to save
    ///  - path: Path to file
    /// - Returns: True if file was saved or if file already exists
    @discardableResult
    func put(file: Data, on path: String) -> Bool {
        let absolutePath = storagePath + path

        return fileManager.createFile(atPath: absolutePath, contents: file)
    }
    
    /// Get file from storage
    /// - Parameters:
    ///  - path: Path to file
    /// - Returns: File
    func get(path: String) throws -> Data {
        let absolutePath = storagePath + path
        guard let data = fileManager.contents(atPath: absolutePath) else {
            throw HBHTTPError(.notFound)
        }
        
        return data
    }
    
    /// Delete file from storage
    /// - Parameters:
    ///  - path: Path to file
    func delete(path: String) throws {
        let absolutePath = storagePath + path
        try fileManager.removeItem(atPath: absolutePath)
    }
    
    /// Check if file exists
    /// - Parameters:
    ///  - path: Path to file
    /// - Returns: True if file exists
    func exists(path: String) -> Bool {
        let absolutePath = storagePath + path
        return fileManager.fileExists(atPath: absolutePath)
    }
    
    /// Check if file does not exist
    /// - Parameters:
    ///  - path: Path to file
    /// - Returns: True if file does not exist
    func missing(path: String) -> Bool {
        return !exists(path: path)
    }
    
    /// Download file from storage
    /// - Parameters:
    ///  - path: Path to file
    ///  - fileName: Name of file to download (optional). If not specified, path will be used
    ///  - headers: Additional headers
    /// - Returns: Response with file
    func download(path: String, fileName: String? = nil, headers: HTTPHeaders = [:]) throws -> HBResponse {
        let file = try get(path: path)
        var headers = headers
        headers.add(name: "Content-Length", value: "\(file.count)")
        headers.add(name: "Content-Type", value: "application/octet-stream")
        headers.add(name: "Content-Disposition", value: #"attachment; filename="\#(fileName ?? path)""#)
        
        return HBResponse(
            status: .ok,
            headers: headers,
            body: .byteBuffer(ByteBuffer(data: file))
        )
    }
    
    func size(path: String) throws -> Int {
        let file = try get(path: path)
        return file.count
    }
    
    /// Copy file in storage
    /// - Parameters:
    ///  - from: Path to file
    ///  - to: Path to file
    func copy(from: String, to: String) throws {
        let absoluteFrom = storagePath + from
        let absoluteTo = storagePath + to

        try fileManager.copyItem(atPath: absoluteFrom, toPath: absoluteTo)
    }
    
    /// Move file in storage
    /// - Parameters:
    ///  - from: Path to file
    ///  - to: Path to file
    func move(from: String, to: String) throws {
        let absoluteFrom = storagePath + from
        let absoluteTo = storagePath + to

        try fileManager.moveItem(atPath: absoluteFrom, toPath: absoluteTo)
    }
    
    /// Make directory in storage
    /// - Parameters:
    ///  - path: Path to directory
    func makeDirectory(path: String) throws {
        let absolutePath = storagePath + path
        try fileManager.createDirectory(atPath: absolutePath, withIntermediateDirectories: true, attributes: nil)
    }
    
    /// Delete directory from storage
    /// - Parameters:
    ///  - path: Path to directory
    func deleteDirectory(path: String) throws {
        let absolutePath = storagePath + path
        try fileManager.removeItem(atPath: absolutePath)
    }
    
    /// Get metadata of file
    /// - Parameters:
    ///  - path: Path to file
    func getMetadata(path: String) throws -> [FileAttributeKey: Any] {
        let absolutePath = storagePath + path
        return try fileManager.attributesOfItem(atPath: absolutePath)
    }
    
    /// Get url of file
    /// - Parameters:
    ///  - path: Path to file
    /// - Returns: URL of file
    func url(path: String) -> URL? {
        guard exists(path: path) else {
            return nil
        }
        let appURL = env("APP_URL", defaultValue: "")
        
        return URL(string: appURL + "/storage/" + path)
    }

}
