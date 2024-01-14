//
//  Button.swift
//
//
//  Created by Matúš Klasovitý on 11/01/2024.
//

import Foundation
import SwiftHtml

protocol Actionable {
    
    var action: () -> Void { get }
    
}


struct Button<Label: View>: View, Tagable, Identifiable, Actionable {
    
    let id: String
    let label: Label
    let action: () -> Void
    
    init(file: String = #file, line: Int = #line, action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        var hasher = Hasher()
        hasher.combine(file)
        hasher.combine(line)
        
        self.id = hasher.finalize().description
        self.label = label()
        self.action = action
    }
    
    var body: some View {
        NeverView()
    }
    
    var children: [any View] {
        [label]
    }
    
    var tag: Tag {
        SwiftHtml.Button {
            ViewRenderer().tagFrom(view: label)
        }
        .attribute("hx-post", "/eva?triggerId=\(id)")
        .attribute("hx-include", "[name='data']")
        .attribute("hx-target", ".component")
        .class("rounded-md bg-indigo-600 px-2.5 py-1.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600")
    }
    
}

//final class MethodsRepository {
//    
//    static let shared = MethodsRepository()
//    
//    private var store: [String: () -> Void] = [:] // [String: () -> Void]()
//    
//    private init() {}
//    
//    func method(for id: String) -> () -> Void {
//        return store[id]!
//    }
//    
//    func register(method: @escaping () -> Void, for id: String) {
//        store[id] = method
//    }
//    
//}


//enum Example: Codable {
//    
//    case changeText(String)
//    case changeNumber(Int)
//    case changeQuote(Quran)
//    
//}
//
//struct Quran: Codable {
//    
//    let surah: String
//    let ayah: String
//    
//}

