//
//  HelloView.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import SwiftHtml

struct HelloView: View {
    
    let title: String
    
    var body: Tag {
        Body {
            Main {
                H1(title)
                P("Lorem ipsum dolor sit")
                
                Ul {
                    for i in 0..<10  {
                        Li("Item \(i)")
                    }
                }
            }
        }
    }
    
}
