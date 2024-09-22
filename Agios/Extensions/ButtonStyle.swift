//
//  ButtonStyle.swift
//  Natega
//
//  Created by Nikola Veljanovski on 9.3.23.
//

import SwiftUI

struct TapToScaleModifier: ViewModifier {
    @State private var isTapped = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isTapped ? 1.08 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6),
                       value: isTapped)
            .simultaneousGesture(
                TapGesture().onEnded {
                    withAnimation {
                        isTapped = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isTapped = false
                        }
                    }
                }
            )
    }
}

extension View {
    func tapToScale() -> some View {
        self.modifier(TapToScaleModifier())
    }
}


struct BouncyButton: ButtonStyle {
    @State private var isTapped = false
    public func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .scaleEffect(x: configuration.isPressed ? 1.08 : 1.0, y: configuration.isPressed ? 1.08 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 1 : 1)
    }
}

struct GrowingButton: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .scaleEffect(x: configuration.isPressed ? 1.1 : 1, y: configuration.isPressed ? 1.1 : 1)
            .animation(.easeOut(duration: 0.3), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 1 : 1)
    }
}
