//
//  UpdateComponent.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 09/06/2025.
//

import SwiftUI

struct UpdateComponent: View {
    @State private var isRotating = false
    @State private var isAnimating = false
    @ObservedObject var versionCheckViewModel: VersionCheckViewModel
    let onTap: (Bool) -> Void
    
    // Generate 5 random animated images
    private let images = (0..<6).map { _ in AnimatedImage.random() }

    var body: some View {
        ZStack {
            if versionCheckViewModel.updateType == .optional {
                ZStack {
                    if !versionCheckViewModel.versionUpdateIsExpanded {
                        Image(systemName: "info.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.primary900)
                            .padding(16)
                            .background(.white)
                            .onTapGesture {
                                withBouncySpringAnimation {
                                    versionCheckViewModel.versionUpdateIsExpanded.toggle()
                                }
                                HapticsManager.instance.impact(style: .light)
                            }
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            VStack(spacing: 16) {
                                ZStack {
                                    Rectangle()
                                        .fill(.linearGradient(colors: [.primary400, .primary300, .white], startPoint: .top, endPoint: .bottom))
                                        .frame(height: 167)

                                    SunBeamView(color: .white)
                                        .rotationEffect(.degrees(isRotating ? 360 : 0))
                                        .offset(y: 30)
                                        .opacity(0.2)
                                        .scaleEffect(2)

                                    Image("app-modal-icon")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 90, height: 90)
                                        .offset(y: isAnimating ? -4 : 4)

                                    ForEach(images) { image in
                                        AnimatedPulseImage(image: image)
                                    }
                                }
                            }
                            .clipShape(
                                Rectangle()
                                    .size(width: UIScreen.main.bounds.width, height: 167)
                            )
                            .frame(height: 167)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Agios just got better!")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.gray900)
                                
                                Text("Enjoy the latest features, improvements, and fixes in Agios.")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.gray500)
                                
                                Button {
                                    onTap(true)
                                    HapticsManager.instance.impact(style: .light)
                                } label: {
                                    Text("Update now")
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity)
                                        .background(.primary900)
                                        .clipShape(RoundedRectangle(cornerRadius: 40))
                                        .padding(.vertical, 16)
                                }
                                .buttonStyle(GrowingButton())
                            }
                            .padding(.horizontal, 16)
                            .kerning(-0.4)
                        }
                        .transition(.scale(scale: 0.5, anchor: .bottomTrailing).combined(with: .opacity))
                        .background(.white)
                        .overlay(alignment: .topTrailing, content: {
                            NavigationButton(labelName: .close, backgroundColor: .primary100, foregroundColor: .primary900)
                                .onTapGesture {
                                    HapticsManager.instance.impact(style: .light)
                                    withBouncySpringAnimation {
                                        versionCheckViewModel.versionUpdateIsExpanded = false
                                    }
                                }
                                .padding(16)
                        })
                        .frame(maxWidth: 500)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 20).repeatForever(autoreverses: false)) {
                                isRotating.toggle()
                            }
                            
                            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                                isAnimating.toggle()
                            }
                        }

                    }
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: versionCheckViewModel.versionUpdateIsExpanded ? 24 : 40, style: .continuous))
                .shadow(color: .gray200, radius: 10, x: 0, y: 8)

            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withBouncySpringAnimation {
                    if versionCheckViewModel.updateType == .optional {
                        versionCheckViewModel.versionUpdateIsExpanded = true
                    }
                }
            }
        }
    }
}

#Preview {
    UpdateComponent(versionCheckViewModel: VersionCheckViewModel(), onTap: {_ in })
}
