//
//  ViewProtocol.swift
//  
//
//  Created by Matúš Klasovitý on 01/01/2024.
//

import Hummingbird
import SwiftHtml

protocol View: HBResponseGenerator {
    
    @TagBuilder var body: Tag { get }
    
}

extension View {
    
    func response(from request: HBRequest) throws -> HBResponse {
        let document = Document(.html) {
            body
        }
        
        let html = DocumentRenderer().render(document)
        
        return HBResponse(
            status: .ok,
            headers: [
                "Content-Type": "text/html"
            ],
            body: .byteBuffer(ByteBuffer(string: html))
        )
    }
    
}


@resultBuilder
struct ViewBuilder {
    
    /// Builds an expression within the builder.
    static func buildExpression<Content: MyView>(_ content: Content) -> Content {
        content
    }
    
    /// Builds an empty view from a block containing no statements.
    static func buildBlock() -> EmptyView {
        EmptyView()
    }
    
    /// Passes a single view written as a child view through unmodified.
    ///
    /// An example of a single view written as a child view is
    /// `{ Text("Hello") }`.
    public static func buildBlock<Content: MyView >(_ content: Content) -> Content {
        content
    }

    static func buildBlock<each Content: MyView>(_ content: repeat each Content) -> TupleView<(repeat each Content)> {
        return TupleView(value: (repeat each content))
    }
    
//    /// Add support for loops.
//    static func buildArray<Content: MyView>(_ components: [Content]) -> Content {
//        components.first!
//    }
    
}

extension ViewBuilder {

    /// Provides support for “if” statements in multi-statement closures,
    /// producing an optional view that is visible only when the condition
    /// evaluates to `true`.
    public static func buildIf<Content: MyView>(_ content: Content?) -> Content? {
        content
    }

    /// Provides support for "if" statements in multi-statement closures,
    /// producing conditional content for the "then" branch.
    public static func buildEither<TrueContent: MyView, FalseContent: MyView>(first: TrueContent) -> ConditionalContent<TrueContent, FalseContent> {
        ConditionalContent(trueContent: first)
    }

    /// Provides support for "if-else" statements in multi-statement closures,
    /// producing conditional content for the "else" branch.
    public static func buildEither<TrueContent: MyView, FalseContent: MyView>(second: FalseContent) -> ConditionalContent<TrueContent, FalseContent> {
        ConditionalContent(falseContent: second)
    }

}

struct ConditionalContent<TrueContent: MyView, FalseContent: MyView>: MyView, Tagable {
    
    var trueContent: TrueContent?
    var falseContent: FalseContent?
    
    init(trueContent: TrueContent) {
        self.trueContent = trueContent
        self.falseContent = nil
    }
    
    init(falseContent: FalseContent) {
        self.trueContent = nil
        self.falseContent = falseContent
    }
    
    var body: MyView {
        EmptyView()
    }
    
    var tag: Tag {
        if let trueContent {
            return ViewRenderer().tagFrom(view: trueContent)
        } else if let falseContent {
            return ViewRenderer().tagFrom(view: falseContent)
        } else {
            return Div()
        }
    }
    
}


struct TupleView<T>: MyView, Tagable {
    
    var value: T
    
    private var values: [Mirror.Child] {
        let mirror = Mirror(reflecting: value)
        
        return mirror.children.map { $0.self }
    }
    
    var body: MyView {
        EmptyView()
    }
    
    var tag: Tag {
        Div {
            for x in values {
                if let content = x.value as? MyView {
                    ViewRenderer().tagFrom(view: content)
                }
            }
        }
    }
    
}


protocol MyView: HBResponseGenerator {
    
    @ViewBuilder var body: MyView { get }
    
}

extension MyView {
    
    func response(from request: HBRequest) throws -> HBResponse {
        let viewRenderer = ViewRenderer()
        
        let html = viewRenderer.render(self)
        
        
        return HBResponse(
            status: .ok,
            headers: [
                "Content-Type": "text/html"
            ],
            body: .byteBuffer(ByteBuffer(string: html))
        )
    }
    
}

protocol Tagable {
    
    var tag: Tag { get }
    
}

struct EmptyView: MyView, Tagable {
    
    var body: MyView {
        self
        // Text(text: "Hello")
    }
    
    var tag: Tag {
        Div()
            .class(add: "none")
    }
    
}


struct Text: MyView, Tagable {
    
    let text: String
    
    var body: MyView {
        self
    }
    
    var tag: Tag {
        P(text)
    }
    
}

extension Text {
    
    func fontWeight(_ weight: FontWeight) -> Text {
        tag.fontWeight(weight)

        return self
    }
    
}

struct Group<Content: MyView>: MyView, Tagable {
    
    let content: Content
    private let viewRenderer = ViewRenderer()
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: MyView {
        content
    }
    
    var tag: Tag {
        Div {
            viewRenderer.tagFrom(view: content)
        }
    }
    
}

class ViewRenderer {
    
    func render(_ view: MyView) -> String {
        let document = Document(.html) {
            Html {
                Head {
                    Script()
                        .src("https://cdn.tailwindcss.com")
                }
                
                Body {
                    tagFrom(view: view)
                }
            }
        }
        
        let html = DocumentRenderer().render(document)
        
        return html
    }
    
    func tagFrom(view: MyView) -> Tag {
        print("Tag from \(type(of: view.self))")
        if let view = view as? Tagable {
            return view.tag
        }
        
        return tagFrom(view: view.body)
    }
    
}

struct MyHelloView: MyView {
    
    var body: MyView {
        Group {
            TitleView(title: "My title")
            if Bool.random() {
                Text(text: "true")
            } else {
                Text(text: "false")
            }
        }
    }
    
}

struct TitleView: MyView {
    
    let title: String
    
    var body: MyView {
        Text(text: title)
            .fontWeight(.bold)
    }
    
}

