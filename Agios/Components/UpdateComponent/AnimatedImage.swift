//
//  AnimatedImage.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 09/06/2025.
//

import SwiftUI

struct AnimatedImage: Identifiable {
    let id = UUID()
    let offset: CGSize
    let size: CGSize
    let delay: Double
    let interval: Double

    static func random() -> AnimatedImage {
        AnimatedImage(
            offset: CGSize(width: CGFloat.random(in: -100...100), height: CGFloat.random(in: -80...80)),
            size: CGSize(width: CGFloat.random(in: 16...45), height: CGFloat.random(in: 16...50)),
            delay: Double.random(in: 0...0.5),
            interval: Double.random(in: 2...3)
        )
    }
}
