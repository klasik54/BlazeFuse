//
//  File.swift
//  
//
//  Created by Matúš Klasovitý on 13/01/2024.
//

import Foundation

protocol Bar {
    
    associatedtype Props: Codable
    associatedtype Data: Codable
    
    var props: Props { get }
    var state: Data { get set }
    
    init(props: Props)
    
}


final class BarRepository {
    
    private var bars: [String: any Bar.Type] = [
        "1": Ee.self
    ]
    
    static let shared = BarRepository()
    
    func getBar(by id: String) -> any Bar.Type {
        return bars[id]!
    }

}

struct Ee: Bar {
   
    let props: Props
    @State var state = Data()
    
    struct Props: Codable {
        
        let id: String
        let title: String

    }
    
    struct Data: Codable {
        var email: String = "default"
    }
    
    
    init(props: Props) {
        self.props = props
    }
    
    func touch() {
        state.email = "ahoj"
    }
   
}

struct DataWrapper<T: Bar>: Codable {
    
    let props: T.Props
    let state: T.Data
    
}

func bb() {
    let barType = BarRepository.shared.getBar(by: "1")
    let bar = decode(bar: barType)
    
    if let ee = bar as? Ee {
        print("Before: \(ee.state.email)")
        ee.touch()
        print("After: \(ee.state.email)")
    }
}

func decode<T: Bar>(bar: T.Type) -> T {
    let json = """
    {
        "props": {
            "id": "1",
            "title": "Ahoj"
        },
        "state": {
            "email": "from request"
        }
    }
    """.data(using: .utf8)
    
    let decoder = JSONDecoder()
    let dataWrapper = try! decoder.decode(DataWrapper<T>.self, from: json!)

    var bar = T.init(props: dataWrapper.props)
    bar.state = dataWrapper.state
    
    
    return bar
}


func findView(by id: String, from view: some View) -> ((any View)?) {
    if let identifiableView = view as? any Identifiable<String>, identifiableView.id == id {
        return view
    } else {
        return findView(by: id, from: view.body)
    }
}
