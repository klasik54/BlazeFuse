import Foundation

do {
    // try FileManager.default.createDirectory(atPath: "./Public/Storage", withIntermediateDirectories: true)
    try FileManager.default.createSymbolicLink(atPath: "./Public/Storage" , withDestinationPath: "../Storage/App/Public/")
} catch {
    print(error)
}