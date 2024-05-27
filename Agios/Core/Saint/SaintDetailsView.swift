//
//  SaintDetailsView.swift
//  Agios
//
//  Created by Victor on 4/25/24.
//

import SwiftUI


struct SaintDetailsView: View {
    
    @EnvironmentObject private var occasionViewModel: OccasionsViewModel
    let icon: IconModel
    let iconographer: Iconagrapher
    @Binding var showImageViewer: Bool
    @Binding var selectedSaint: IconModel?
    var namespace: Namespace.ID
    
    @State private var offset: CGSize = .zero
    @State private var bottomOffset: CGSize = .zero
    @State private var topOffset: CGSize = .zero
    @State private var position: CGSize = .zero
    @State private var swipeVelocity: CGFloat = 0
    @State private var startValue: CGFloat = 0
    @State private var endValue: CGFloat = 0
    @State private var resetDrag: Bool = false
    @State private var currentScale: CGFloat = 1.0
    
    @EnvironmentObject var viewModel: IconImageViewModel
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        VStack(alignment: .leading, spacing: 32) {
                            if !showImageViewer {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .fill(.clear)
                                    .frame(height: 420)
                                    .background(
                                        ZStack(content: {
                                            if let image = viewModel.image {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .matchedGeometryEffect(id: "\(icon.id)", in: namespace)
                                                    .transition(.scale(scale: 1))
                                                    .zIndex(4)
                                                    .onTapGesture {
                                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                                            showImageViewer = true
                                                        }
                                                    }
                                                    .transition(.scale(scale: 1))
                                            }
                                        })
                                        
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                    .matchedGeometryEffect(id: "bound", in: namespace)
                                
         
                            } else {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 353, height: 460)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text(icon.caption ?? "")
                                    .font(.title2)
                                .fontWeight(.semibold)
                                
                                
                                Text("\(occasionViewModel.iconagrapher?.name ?? "None")")
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
                    .foregroundStyle(.gray900)
                    
                }
                
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .opacity(startValue > 0 ? 1 : getScaleAmount())
                        .zIndex(10)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                showImageViewer = false
                                endValue = 0
                                startValue = 0
                            }
                    }
                        .allowsHitTesting(startValue > 0 ? false : true)
                }
                .opacity(showImageViewer ? 1 : 0)

                
                
                 
                if showImageViewer {
                    
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(.clear)
                        .background(
                            ZStack(content: {
                                if let image = viewModel.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .zoomable()
                                        .matchedGeometryEffect(id: "\(icon.id)", in: namespace)
                                        .zIndex(10)
                                        .transition(.scale(scale: 1))
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                                showImageViewer = true
                                            }
                                        }
                                    .scaleEffect(1 + startValue)
                                    .offset(x: startValue > 0.2 ? offset.width + position.width : .zero, y: startValue > 0 ? offset.height + position.height : .zero)
                                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("MagnifyGestureScaleChanged"))) { obj in
                                            if let scale = obj.object as? CGFloat {
                                                withAnimation {
                                                    currentScale = scale
                                                }
                                                
                                            }
                                        }
                                }
                            })
                            
                           
                            .offset(offset)
                            .scaleEffect(getScaleAmount())
                            .transition(.scale(scale: 1))
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
                                            
                                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                                showImageViewer = false
                                                HapticsManager.instance.impact(style: .light)
                                            }
                                        }
                                    })
                                : nil
                            )
                                
                        )
                        .matchedGeometryEffect(id: "bound", in: namespace)
                       

                }
                
                
                
                
            }
            .overlay(alignment: .topTrailing) {
                
            }
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(.primary100)
                    .ignoresSafeArea()
            )
            .mask {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .ignoresSafeArea()
        }
            ZStack {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selectedSaint = nil
                        showImageViewer = false
                        endValue = 0
                        startValue = min(max(startValue, 0), 0.2)
                    }
                    
                } label: {
                    NavigationButton(labelName: .close, backgroundColor: .primary300, foregroundColor: .primary1000)
                }
                .padding(20)
                .opacity(showImageViewer ? 1 : 0)
            }
            .opacity(getScaleAmount() < 1 || currentScale > 1 ? 0 : 1)
            .zIndex(showImageViewer ? 0 : -2)
        }
    }
    
    private func getScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.height / 2
        let currentAmount = abs(offset.height)
        let percentage = currentAmount / max
        let scaleAmount = 1.0 - min(percentage, 0.5) * 0.75
        
        // Check if the scale amount is below a certain threshold
        if scaleAmount < 0.4 {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                showImageViewer = false
                selectedSaint = nil
            }
        }
         
        return scaleAmount
    }

    
    private func getCornerRadius() -> CGFloat {
        let minCornerRadius: CGFloat = 0
        let maxCornerRadius: CGFloat = 80
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
            .environmentObject(ImageViewerViewModel())
    }
}


extension SaintDetailsView {
    private var description: some View {
        VStack(alignment: .leading, spacing: 16) {
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
        .textSelection(.enabled)

    }
    
    private var commemoration: some View {
        VStack(alignment: .leading, spacing: 16) {
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
        .textSelection(.enabled)

    }
    
    private var highlights: some View {
        VStack(alignment: .leading, spacing: 16) {
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
        .textSelection(.enabled)

    }
    
    private var divider: some View {
        Divider()
            .background(.gray50)
    }
}



