//
//  ImageViewer.swift
//  Agios
//
//  Created by Victor on 4/28/24.
//

import SwiftUI
import SwiftUIX

struct ImageViewer: View {
    let icon: IconModel
    @Binding var showImageViewer: Bool
    @Binding var selectedSaint: IconModel?
    //@EnvironmentObject private var occasionalViewModel: OccasionsViewModel
    @GestureState var dragginfOffset: CGSize = .zero
    
    
    @State var openSaint: Bool = false
    @State var imageViewerOffset: CGSize = .zero
    @State var backgroundOpacity: Double = 1
    @State var imageScaling: Double = 1
    
    
    var body: some View {
        ZStack {
            VisualEffectBlurView(blurStyle: .dark)
                .intensity(backgroundOpacity)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.snappy) {
                        selectedSaint = nil
                        showImageViewer = false
                    }
                }
            
            SaintImageView(icon: selectedSaint ?? dev.icon)
                .aspectRatio(contentMode: .fit)
                .scaleEffect(selectedSaint == icon ? (imageScaling > 1 ? imageScaling : 1) : 1)
                
                // for smooth animation movement
                .offset(y : imageViewerOffset.height)
                .gesture(
                    //Magnifying gesture
                    MagnificationGesture().onChanged({ value in
                        imageScaling = value
                    }).onEnded({ _ in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 1)) {
                            imageScaling = 1
                        }
                    })
                    
                    // double tap to zoom
                    .simultaneously(with: TapGesture(count: 2).onEnded({
                        withAnimation {
                            imageScaling = imageScaling < 1 ? 1 : 4
                        }
                    }))
                )
        }
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation(.snappy) {
                    selectedSaint = nil
                    showImageViewer = false
                }
                
            } label: {
                NavigationButton(labelName: .close, backgroundColor: .gray800, foregroundColor: .gray50)
            }
            .padding(20)

            
        }
        .gesture(DragGesture().updating($dragginfOffset, body: { value, outValue, _ in
            outValue = value.translation
            onChange(value: value)
        }).onEnded(onEnd(value:)))
    }
    
    func onChange(value: DragGesture.Value) {
        // updating offset
        let newValue = CGSize(width: value.translation.width, height: value.translation.height)
        imageViewerOffset = newValue
        
        //calculating blur intensity
        let halfHeight = UIScreen.main.bounds.height / 2
        let progress = value.translation.height / halfHeight
        
        withAnimation(.default) {
            backgroundOpacity = Double(1 - (progress < 0 ? -progress : progress))
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 1)) {
            let translation = value.translation.height
            
            if translation <  0 {
                imageViewerOffset = .zero
                backgroundOpacity = 1
            } else if translation < 250 {
                imageViewerOffset = .zero
                backgroundOpacity = 1
            } else {
                selectedSaint = nil
                openSaint = false
                imageViewerOffset = .zero
                backgroundOpacity = 1
            }
        }
    }
}


#Preview {
    ImageViewer(icon: dev.icon, showImageViewer: .constant(false), selectedSaint: .constant(dev.icon))
}
