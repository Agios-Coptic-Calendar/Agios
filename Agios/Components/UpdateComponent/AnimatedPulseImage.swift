//
//  AnimatedPulseImage.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 09/06/2025.
//

import SwiftUI

struct AnimatedPulseImage: View {
    let image: AnimatedImage
    @State private var scale: CGFloat = 0
    @State private var currentOffset: CGSize
    @State private var currentSize: CGSize
    @State private var timer: Timer?

    init(image: AnimatedImage) {
        self.image = image
        // Initialize with random values
        self._currentOffset = State(initialValue: CGSize(
            width: CGFloat.random(in: -100...100),
            height: CGFloat.random(in: -80...80)
        ))
        self._currentSize = State(initialValue: CGSize(
            width: CGFloat.random(in: 16...45),
            height: CGFloat.random(in: 16...50)
        ))
    }

    var body: some View {
        Image("wide")
            .resizable()
            .scaledToFill()
            .scaleEffect(scale)
            .frame(width: currentSize.width, height: currentSize.height)
            .offset(currentOffset)
            .onAppear {
                animate()
            }
            .onDisappear {
                timer?.invalidate()
            }
    }

    private func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + image.delay) {
            startAnimationCycle()
        }
    }
    
    private func startAnimationCycle() {
        timer = Timer.scheduledTimer(withTimeInterval: image.interval, repeats: true) { _ in
            let newOffset = CGSize(
                width: CGFloat.random(in: -100...100),
                height: CGFloat.random(in: -80...80)
            )
            let newSize = CGSize(
                width: CGFloat.random(in: 16...45),
                height: CGFloat.random(in: 16...50)
            )
            
            // Update position and size instantly
            currentOffset = newOffset
            currentSize = newSize
            
            // Scale up
            withAnimation(.easeInOut(duration: 0.6)) {
                scale = 1
            }
            
            // Scale down after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    scale = 0
                }
            }
        }
        
        // Fire immediately for the first animation
        timer?.fire()
    }
}
