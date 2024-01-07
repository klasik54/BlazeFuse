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
    
    public func response(from request: HBRequest) throws -> HBResponse {
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
    }
    
    var tag: Tag {
        Div()
            .class(add: "none")
    }
    
}


struct Text: MyView, Tagable {
    
    let text: String
    
    private init(text: String, tag: Tag) {
        self.text = text
        self.tag = tag
    }
    
    init(text: String) {
        self.text = text
        self.tag = P(text)
    }
    
    var body: MyView {
        self
    }
    
    var tag: Tag
    
}

extension Text {
    
    func fontWeight(_ weight: FontWeight) -> Text {
        return Text(text: text, tag: tag.fontWeight(weight))
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
    
    func tagFrom<T: MyView>(view: T, classList: [String] = []) -> Tag {
        print("View", type(of: view))
        print("Body", type(of: view.body))
        var classList = classList
        let mirror = Mirror(reflecting: view)
        mirror.children.forEach {
            if let aa = $0.value as? ViewModifier {
                print("Class", aa.className)
                classList.append(aa.className)
            }
        }
        
        
        if let view = view as? Tagable {
            return view.tag
                .class(add: classList.joined(separator: " "))
        }
      
        return tagFrom(view: view.body, classList: classList)
    }
    
}




protocol ViewModifier {
    
    var className: String { get }
    
}

struct ModifiedContent<Content, Modifier> {
    
    let content: Content
    let modifier: Modifier
    
//    var body: MyView {
//        content.body
//    }
    
}

extension Never: MyView {
    
    var body: MyView {
        fatalError()
    }
    
}

extension MyView {
    
    func foregroundColor(_ color: Color) -> some MyView {
        return ModifiedContent(content: self, modifier: ForegroundColorModifier(color: color))
    }
    
    func padding(_ padding: Float) -> some MyView {
        return ModifiedContent(content: self, modifier: PaddingModifier(padding: padding))
    }
    
    func backgoundColor(_ color: Color) -> some MyView {
        return ModifiedContent(content: self, modifier: BackgroundColorModifier(color: color))
    }
    
}


struct ForegroundColorModifier: ViewModifier {
    
    let color: Color
    var className: String {
        "text-\(color.className)"
    }
    
}

struct PaddingModifier: ViewModifier {
    
    let padding: Float
    
    var className: String {
        "p-[\(padding)px]"
    }
    
}

struct BackgroundColorModifier: ViewModifier {
    
    let color: Color
    var className: String {
        "bg-\(color.className)"
    }
    
}




extension ModifiedContent: HBResponseGenerator where Content: MyView, Modifier: ViewModifier {
    
    func response(from request: HBRequest) throws -> HBResponse {
        return try content.response(from: request)
    }

}

extension ModifiedContent: MyView where Content: MyView, Modifier: ViewModifier {
    
    var body: MyView {
        content
    }
    
}

//extension ModifiedContent: Tagable where Content: MyView & Tagable, Modifier: ViewModifier {
//    
//    var tag: Tag {
//        content.tag
//    }
//    
//}

struct MyHelloView: MyView {
    
    var body: MyView {
        Text(text: "Hello")
            .padding(10)
            .foregroundColor(.red700)
            .backgoundColor(.blue500)

//        Group {
//            TitleView(title: "My title")
//            if Bool.random() {
//                Text(text: "true")
//            } else {
//                Text(text: "false")
//            }
//        }
    }
    
}

struct TitleView: MyView {
    
    let title: String
    
    var body: MyView {
        Text(text: title)
            .fontWeight(.bold)
            .foregroundColor(.red50)
            .padding(10)
    }
    
}

