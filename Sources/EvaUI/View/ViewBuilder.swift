//
//  ViewBuilder.swift
//  
//
//  Created by Matúš Klasovitý on 07/01/2024.
//

import Foundation

@resultBuilder
struct ViewBuilder {
    
    /// Builds an expression within the builder.
    static func buildExpression<Content: View>(_ content: Content) -> Content {
        content
    }
    
    /// Builds an empty view from a block containing no statements.
    static func buildBlock() -> EmptyView {
        EmptyView()
    }
    
    /// Support for optional values
    static func buildOptional<Content: View>(_ content: Content?) -> ConditionalContent<Content, EmptyView> {
        if let content {
            return ConditionalContent(trueContent: content)
        } else {
            return ConditionalContent(falseContent: EmptyView())
        }
    }
    
    /// Passes a single view written as a child view through unmodified.
    ///
    /// An example of a single view written as a child view is
    /// `{ Text("Hello") }`.
    public static func buildBlock<Content: View >(_ content: Content) -> Content {
        content
    }

    static func buildBlock<each Content: View>(_ content: repeat each Content) -> TupleView<(repeat each Content)> {
        return TupleView(value: (repeat each content))
    }
    
}

extension ViewBuilder {

    /// Provides support for “if” statements in multi-statement closures,
    /// producing an optional view that is visible only when the condition
    /// evaluates to `true`.
    public static func buildIf<Content: View>(_ content: Content?) -> Content? {
        content
    }

    /// Provides support for "if" statements in multi-statement closures,
    /// producing conditional content for the "then" branch.
    public static func buildEither<TrueContent: View, FalseContent: View>(first: TrueContent) -> ConditionalContent<TrueContent, FalseContent> {
        ConditionalContent(trueContent: first)
    }

    /// Provides support for "if-else" statements in multi-statement closures,
    /// producing conditional content for the "else" branch.
    public static func buildEither<TrueContent: View, FalseContent: View>(second: FalseContent) -> ConditionalContent<TrueContent, FalseContent> {
        ConditionalContent(falseContent: second)
    }

}

//struct OptionalContent<Content: View>: View {
//    let content: Content?
//    
//    init(_ content: Content?) {
//        self.content = content
//    }
//    
//    var body: some View {
//        content ?? EmptyView()
//    }
//
//}
