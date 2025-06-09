//
//  SpringAnimation.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 09/06/2025.
//

import SwiftUI

func withBouncySpringAnimation(_ action: @escaping () -> Void) {
    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
        action()
    }
}

