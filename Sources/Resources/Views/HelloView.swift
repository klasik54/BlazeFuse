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
        Html {
            Head {
                Script()
                    .src("https://cdn.tailwindcss.com")
            }
        }
        Body {
            Main {
                H1(title)
//                VStack {
//                    P("Lorem ipsum dolor sit")
//                        .font(.title)
//                        .foregroundColor(.red700)
//                        .background(.green700)
//                        .padding(.vertical, 4)
//                        .margin(.horizontal, 4)
//                        .rounded()
//                    
//                }
                P("Lorem ipsum dolor sit")
                    .font(.title)
                    .foregroundColor(.red700)
                    .background(.green700)
                    .padding(.vertical, 4)
                    .margin(.horizontal, 4)
                    .rounded()
                
                P("Hello")
                    .background(.green50)
                
                Ul {
                    for i in 0..<10  {
                        Li("Item \(i)")
                    }
                }
            }
            .padding(20)
        }
    }
    
}




struct RadiusSize {
    
    static let sm = RadiusSize(className: "sm")
    static let md = RadiusSize(className: "md")
    static let lg = RadiusSize(className: "lg")
    static let xl = RadiusSize(className: "xl")
    static let full = RadiusSize(className: "full")
    
    let className: String
    
}

extension Tag {
    
    func rounded(_ corners: Corner = .all, _ radius: RadiusSize = .md) -> Tag {
        self.class(add: "rounded-\(radius.className)")
    }
    
    func foregroundColor(_ color: Color) -> Tag {
        self.class(add: "text-\(color.className)")
    }
    
    func background(_ color: Color) -> Tag {
        self.class(add: "bg-\(color.className)")
    }
    
}
