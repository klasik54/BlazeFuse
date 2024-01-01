//
//  RegisterView.swift
//
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import SwiftHtml

struct RegisterView: View {
    
    var body: Tag {
        Body {
            Form {
                Input()
                    .name("username")
                    .placeholder("Username")
                
                Input()
                    .name("password")
                    .type(.password)
                    .placeholder("Password")

                Button("Register")
            }
        }
    }
    
}
