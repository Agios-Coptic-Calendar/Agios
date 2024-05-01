//
//  SaintDetailsView.swift
//  Agios
//
//  Created by Victor on 4/25/24.
//

import SwiftUI
import SwiftUIX

struct SaintDetailsView: View {
    
    let icon: IconModel
    let iconographer: Iconagrapher
    @Binding var showImageViewer: Bool
    @Binding var selectedSaint: IconModel?
    @EnvironmentObject private var occasionalViewModel: OccasionsViewModel
    var namespace: Namespace.ID
    
    @State var offset: CGSize = .zero
    @State var bottomOffset: CGSize = .zero
    @State var topOffset: CGSize = .zero
    @State var position: CGSize = .zero
    @State var swipeVelocity: CGFloat = 0
    @State var startValue: CGFloat = 0
    @State var endValue: CGFloat = 0
    @State var resetDrag: Bool = false
    @State private var currentScale: CGFloat = 1.0
    
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
    //                    Button {
    //                        occasionalViewModel.openSaint = false
    //                        selectedSaint = nil
    //                        HapticsManager.instance.impact(style: .light)
    //                    } label: {
    //                        NavigationButton(labelName: .down, backgroundColor: .primary300)
    //                            .padding(.horizontal, 20)
    //                    }
    //                    .buttonStyle(BouncyButton())
                        
                        VStack(alignment: .leading, spacing: 32) {
                            if !showImageViewer {
                                ZStack {
                                    SaintImageView(icon: icon)
                                        .frame(width: !showImageViewer ? 353 : UIScreen.main.bounds.width, height: 337, alignment: .center)
                                        
                                        .aspectRatio(contentMode: .fill)
                                        .mask {
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .matchedGeometryEffect(id: "\(icon.image)", in: namespace)
                                        }
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                                showImageViewer = true
                                                selectedSaint = icon
                                            }
                                        }
                                        .matchedGeometryEffect(id: "\(icon.id)", in: namespace)
                                        .transition(.scale(scale: 1))
                                        .zIndex(3)
                                        .offset(offset)
                                        .scaleEffect(showImageViewer ? 1 : getScaleAmount())
                                }
                                
                                    
                                
                            } else {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 353, height: 337)
                            }
                            
                            
                        

                            VStack(alignment: .leading, spacing: 12) {
                                Text(icon.caption ?? "")
                                    .font(.title2)
                                .fontWeight(.semibold)
                                
                                
                                Text("Iconographer - \(iconographer.name ?? "Non")")
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 4)
                                    .background(.primary300)
                                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        divider
                        description
                        divider
                        commemoration
                        divider
                        highlights
                    }
                    .kerning(-0.4)
                    .padding(.vertical, 24)
                    .fontDesign(.rounded)
                    
                }
                
                ZStack {
                    Rectangle()
                        .opacity(startValue > 0 ? 1 : getScaleAmount())
                        .zIndex(2)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                showImageViewer = false
                                selectedSaint = icon
                                endValue = 0
                                startValue = 0
                            }
                    }
                        .allowsHitTesting(startValue > 0 ? false : true)
                }
                .opacity(showImageViewer ? 1 : 0)
                
                if showImageViewer {
    //                VisualEffectBlurView(blurStyle: .dark)
    //                    .intensity(showImageViewer ? 1 : 0)
                    
                    
                    ZStack {
                        SaintImageView(icon: icon)
                            .frame(width: !showImageViewer ? UIScreen.main.bounds.width : 353, height: 337, alignment: .center)
                            .aspectRatio(contentMode: .fill)
                            .mask {
                                RoundedRectangle(cornerRadius: currentScale > 1 ? 0 : getCornerRadius(), style: .continuous)
                                    .matchedGeometryEffect(id: "\(icon.image)", in: namespace)
                            }
                            .matchedGeometryEffect(id: "\(icon.id)", in: namespace)
                            .transition(.scale(scale: 1))
                            .scaleEffect(1 + startValue)
                            .offset(x: startValue > 0.2 ? offset.width + position.width : .zero, y: startValue > 0 ? offset.height + position.height : .zero)
                            .zoomable()
                            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("MagnifyGestureScaleChanged"))) { obj in
                                    if let scale = obj.object as? CGFloat {
                                        withAnimation {
                                            currentScale = scale
                                        }
                                        
                                    }
                                }
                            
                        /*
                         .gesture( startValue > 0.4 ?
                             DragGesture()
                                 .onChanged { value in
                                     // Adjust the offset only when dragging the image
                                     withAnimation(.spring) {
                                         offset = value.translation
                                     }
                                 }
                                 .onEnded { value in
                                     // Reset offset if needed
                                     if startValue < 0.7 {
                                         position = .zero
                                     } else {
                                         withAnimation(.spring) {
                                             
                                             let proposedWidth = position.width + value.translation.width
                                             let proposedHeight = position.height + value.translation.height
                                             
                                             // Define maximum and minimum width and height
                                             let maxWidth: CGFloat = startValue > 0.4 ? 320 : 200
                                             let minWidth: CGFloat = startValue > 0.4 ? -320 : -200
                                             let maxHeight: CGFloat = startValue > 0.4 ? 150 : 100
                                             var minHeight: CGFloat = -100
                                             
                                             // Ensure position doesn't exceed maximum and minimum width and height
                                             position.width = min(maxWidth, max(minWidth, proposedWidth))
                                             position.height = min(maxHeight, max(minHeight, proposedHeight))
                                             offset = .zero
                                             
                                             
                                             
                                             print("Current position with is: \(position.width) and current position height is: \(position.height)")
                                         }
                                     }
                                     
                                 }
                                   : nil
                         )
                         */


                            
                    }
                    .zIndex(3)
                    .offset(offset)
                    .scaleEffect(getScaleAmount())
                    
                    .simultaneousGesture(
                        currentScale <= 1 ?
                        DragGesture()
                            .onChanged({ value in
                                if startValue <= 0 {
                                    withAnimation {
                                        offset = value.translation
                                    }
                                }
                                
                            })
                            .onEnded({ value in
                                if startValue <= 0 {
                                    withAnimation(.spring(response: 0.30, dampingFraction: 1)) {
                                        offset = .zero
                                    }
                                    
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                                        showImageViewer = false
                                        selectedSaint = icon
                                    }
                                }
                                
                                
                            })
                        : nil
                    )
                    /*
                     .gesture(
                         MagnificationGesture()
                             .onChanged({ value in
                                 withAnimation {
                                     startValue = value - 1
                                     endValue = value
                                 }
                                 //print(startValue)
                             })
                             .onEnded({ value in
                                 withAnimation() {
                                     if startValue < 0 {
                                         startValue = 0
                                         HapticsManager.instance.impact(style: .soft)
                                     } else if startValue > 1.7 {
                                         startValue = 1.7
                                         HapticsManager.instance.impact(style: .soft)
                                         //endValue = startValue
                                         
                                     }
                                     print(startValue)
                                     
                                     if startValue <= 0.5 {
                                         position.width = .zero
                                         position.height = .zero
                                     }
                                     
                                    
                                 }
                             })
                     )
                     */

                    /*
                     .simultaneousGesture(
                         DragGesture()
                             .onChanged({ value in
                                 if startValue <= 0 {
                                     withAnimation {
                                         offset = value.translation
                                     }
                                 }
                                 
                             })
                             .onEnded({ value in
                                 if startValue <= 0 {
                                     withAnimation(.spring(response: 0.30, dampingFraction: 1)) {
                                         offset = .zero
                                     }
                                     
                                     withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                                         showImageViewer = false
                                         selectedSaint = icon
                                     }
                                 }
                                 
                                 
                             })
                     )
                     */

                     
                    
                    .onTapGesture(count: 2, perform: {
                        withAnimation(.spring(response: 0.30, dampingFraction: 1)) {
                            startValue = 0
                            resetDrag = true
                            offset = .zero
                            startValue = 0
                        }
                        
                    })
                    
                    

                }
                
                
                
                
            }
            .overlay(alignment: .topTrailing) {
                
            }
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(.primary100)
                    .ignoresSafeArea()
                  //  .matchedGeometryEffect(id: "saintBackground", in: namespace)
            )
            .mask {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .ignoresSafeArea()
                  //  .matchedGeometryEffect(id: "saintView", in: namespace)
        }
            ZStack {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        selectedSaint = nil
                        showImageViewer = false
                        endValue = 0
                        startValue = min(max(startValue, 0), 0.2)
                    }
                    
                } label: {
                    NavigationButton(labelName: .close, backgroundColor: .gray800, foregroundColor: .gray50)
                }
                .padding(20)
                .opacity(showImageViewer ? 1 : 0)
            }
            .opacity(getScaleAmount() < 1 || currentScale > 1 ? 0 : 1)
            .zIndex(showImageViewer ? 0 : -2)
        }
//        .overlay {
//            if showImageViewer {
//                ImageViewer(icon: selectedSaint ?? dev.icon, showImageViewer: $showImageViewer, selectedSaint: $selectedSaint)
//            }
//            
//        }
        

    }
    
    private func getScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.height / 2
        let currentAmount = abs(offset.height)
        let percentage = currentAmount / max
        let scaleAmount = 1.0 - min(percentage, 0.5) * 0.5
        
        // Check if the scale amount is below a certain threshold
        if scaleAmount < 0.7 {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                showImageViewer = false
                selectedSaint = nil
            }
        }
         
        return scaleAmount
    }

    
    private func getCornerRadius() -> CGFloat {
        let minCornerRadius: CGFloat = 12
        let maxCornerRadius: CGFloat = 64
        let scaleFactor = getScaleAmount()
        return minCornerRadius + (maxCornerRadius - minCornerRadius) * (1 - scaleFactor)
    }
    
    private func calculatePositionDistance() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width / 3
        let currentScale = startValue
        let positionDistance = screenWidth - currentScale
        return positionDistance
    }

}


struct SaintDetailsView_Preview: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        SaintDetailsView(icon: dev.icon, iconographer: dev.iconagrapher, showImageViewer: .constant(false), selectedSaint: .constant(dev.icon), namespace: namespace)
            .environmentObject(OccasionsViewModel())
            .environmentObject(IconImageViewModel(icon: dev.icon))
    }
}


extension SaintDetailsView {
    private var description: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "book.pages")
                    .foregroundStyle(.gray400)
                
                Text("Description")
                    .fontWeight(.semibold)
            }
            .font(.title3)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Lorem ipsum dolor sit amet consectetur. Quam malesuada ut magna consectetur. Elementum scelerisque mauris sed maecenas nisi faucibus vitae. Sed mattis sit amet quam. Id mauris.")
                    .foregroundStyle(.gray400)
                    .fontWeight(.medium)
                
                HStack(alignment: .center, spacing: 4) {
                    Text("Read more")
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                
            }
        }
        .padding(.horizontal, 20)

    }
    
    private var commemoration: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "star")
                    .foregroundStyle(.gray400)
                
                Text("Commemoration")
                    .fontWeight(.semibold)
            }
            .font(.title3)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Lorem ipsum dolor sit amet consectetur. Quam malesuada ut magna consectetur. Elementum scelerisque mauris sed maecenas nisi faucibus vitae. Sed mattis sit amet quam. Id mauris.")
                    .foregroundStyle(.gray400)
                    .fontWeight(.medium)
                
                HStack(alignment: .center, spacing: 4) {
                    Text("Read more")
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                
            }
        }
        .padding(.horizontal, 20)

    }
    
    private var highlights: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "rays")
                    .foregroundStyle(.gray400)
                
                Text("Highlights")
                    .fontWeight(.semibold)
            }
            .font(.title3)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Lorem ipsum dolor sit amet consectetur. Quam malesuada ut magna consectetur. Elementum scelerisque mauris sed maecenas nisi faucibus vitae. Sed mattis sit amet quam. Id mauris.")
                    .foregroundStyle(.gray400)
                    .fontWeight(.medium)
                
                HStack(alignment: .center, spacing: 4) {
                    Text("Read more")
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                
            }
        }
        .padding(.horizontal, 20)

    }
    
    private var divider: some View {
        Divider()
            .background(.gray50)
    }
}



