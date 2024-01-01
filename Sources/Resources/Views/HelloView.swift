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
                    Li("Item 1")
                    Li("Item 2")
                    Li("Item 3")
                }
            }
        }
    }
    
}
