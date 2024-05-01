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
            .animation(.spring(response: 0.4, dampingFraction: 0.6))
            .simultaneousGesture(TapGesture().onEnded {
                withAnimation {
                    isTapped.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isTapped.toggle()
                    }
                }
            })
    }
}


struct BouncyButton: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .scaleEffect(x: configuration.isPressed ? 0.95 : 1.0, y: configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.5 : 1)
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
