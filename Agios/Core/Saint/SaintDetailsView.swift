//
//  SaintDetailsView.swift
//  Agios
//
//  Created by Victor on 4/25/24.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var icon: IconModel?
    let story: Story
    
    @State private var showImageViewer = false
    @State private var selectedSaint: IconModel? = nil
    var namespace: Namespace.ID
    
    var body: some View {
        if let icon = icon {
            SaintDetailsView(
                icon: icon,
                iconographer: dev.iconagrapher,
                stories: story,
                showImageViewer: $showImageViewer,
                selectedSaint: $selectedSaint,
                namespace: namespace
            )
            
        }
    }
}

struct SaintDetailsView: View {
    
    @EnvironmentObject private var occasionViewModel: OccasionsViewModel
    let icon: IconModel
    let iconographer: Iconagrapher
    let stories: Story
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
    @State private var descriptionHeight: Int = 3
    @State private var storyHeight: Int = 6
    @State private var openSheet: Bool? = false
    @StateObject private var viewModel: IconImageViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(icon: IconModel, iconographer: Iconagrapher, stories: Story, showImageViewer: Binding<Bool>, selectedSaint: Binding<IconModel?>, namespace: Namespace.ID) {
        _viewModel = StateObject(wrappedValue: IconImageViewModel(icon: icon))
        self.iconographer = iconographer
        self.stories = stories
        self._showImageViewer = showImageViewer
        self._selectedSaint = selectedSaint
        self.namespace = namespace
        self.icon = icon
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: icon.explanation?.isEmpty ?? true ? 16 : 32) {
                        VStack(alignment: .leading, spacing: 32) {
                            if !showImageViewer {
                              fitImageView
                            } else {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 353, height: 460)
                            }
                            iconCaption
                        }
                        .padding(.horizontal, 20)
                        
                        if let explanation = icon.explanation, !explanation.isEmpty {
                            divider
                        }
                        description
                        story
                        //divider
                        //highlights
                    }
                    .kerning(-0.4)
                    .padding(.bottom, 40)
                    .padding(.top, 118)
                    .fontDesign(.rounded)
                    .foregroundStyle(.gray900)
                }
                .overlay(alignment: .top) {
                    ZStack(alignment: .leading) {
                        VariableBlurView(maxBlurRadius: 15, direction: .blurredTopClearBottom, startOffset: 0)
                            .blur(radius: 3)
                            .frame(height: 102)
                            .ignoresSafeArea()
                        customBackButton
                    }
                    
                }
                
                    blurredOverlay
                    filledImageView
   
            }

           closeButton
            
        }
        .halfSheet(showSheet: $openSheet) {
            StoryDetailView(story: stories)
                .presentationDetents([.medium, .large])
                .environmentObject(occasionViewModel)
        } onDismiss: {}
        .onAppear {
            withAnimation {
                showImageViewer = false
            }
           
        }
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.primary100)
                //.ignoresSafeArea()
                //.matchedGeometryEffect(id: "\(icon.caption)", in: namespace)
        )
        .mask {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                //.ignoresSafeArea()
                //.matchedGeometryEffect(id: "m", in: namespace)
    }
    }
    
    private func getScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.height / 2
        let currentAmount = abs(offset.height)
        let percentage = currentAmount / max
        let scaleAmount = 1.0 - min(percentage, 0.5) * 0.75
        
        // Check if the scale amount is below a certain threshold
        if scaleAmount < 0.4 {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                showImageViewer = false
                selectedSaint = nil
                occasionViewModel.viewState = .expanded
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
        SaintDetailsView(icon: dev.icon, iconographer: dev.iconagrapher, stories: dev.story, showImageViewer: .constant(false), selectedSaint: .constant(dev.icon), namespace: namespace)
            .environmentObject(dev.occasionsViewModel)
            //.environmentObject(dev.imageViewModel)
    }
}


extension SaintDetailsView {
    private var customBackButton: some View {
        ZStack {
            Button {
                presentationMode.wrappedValue.dismiss()
                selectedSaint = nil
                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                    occasionViewModel.saintTapped = false
                    occasionViewModel.viewState = .collapsed
                    occasionViewModel.selectedSaint = nil
                }
                HapticsManager.instance.impact(style: .light)
                
            } label: {
                NavigationButton(labelName: .back, backgroundColor: .primary300, foregroundColor: .primary1000)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
            .opacity(showImageViewer ? 0 : 1)
        }
        .opacity(getScaleAmount() < 1 || currentScale > 1 ? 0 : 1)
        .zIndex(showImageViewer ? -2 : 0)
        .offset(y: 23)
    }
    
    private var closeButton: some View {
        ZStack {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                    //selectedSaint = nil
                    showImageViewer = false
                    endValue = 0
                    startValue = min(max(startValue, 0), 0.2)
                    occasionViewModel.showImageView = false
                    selectedSaint = nil
                    occasionViewModel.viewState = .expanded
                    occasionViewModel.stopDragGesture = false
                }
                
            } label: {
                NavigationButton(labelName: .close, backgroundColor: .primary300, foregroundColor: .primary1000)
            }
            .padding(20)
            .opacity(showImageViewer ? 1 : 0)
        }
        .opacity(getScaleAmount() < 1 || currentScale > 1 ? 0 : 1)
        .zIndex(showImageViewer ? 0 : -2)
        .offset(y: 40)

    }
    private var filledImageView: some View {
        ZStack {
            if showImageViewer {
                VStack {}
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .background(
                    SaintImageView(icon: icon)
                        .matchedGeometryEffect(id: "\(icon.id)", in: namespace)
                        .scaledToFit()
                        .transition(.scale(scale: 1))
                        .zoomable()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
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
                                    let dragThreshold: CGFloat = 100
                                    
                                    if abs(value.translation.height) > dragThreshold {
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                            showImageViewer = false
                                            occasionViewModel.viewState = .expanded
                                            selectedSaint = nil
                                            offset = .zero
                                            HapticsManager.instance.impact(style: .light)
                                            occasionViewModel.stopDragGesture = false
                                            occasionViewModel.showImageView = false
                                        }
                                    } else {
                                        withAnimation(.spring(response: 0.30, dampingFraction: 1)) {
                                            offset = .zero
                                        }
                                    }
                                })
                            : nil
                        )
                )
                .mask({
                    RoundedRectangle(cornerRadius: 0)
                        .matchedGeometryEffect(id: "\(icon.image)", in: namespace)
                })
                

            }
        }
    }
    private var blurredOverlay: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(startValue > 0 ? 1 : getScaleAmount())
                .zIndex(10)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                        showImageViewer = false
                        occasionViewModel.viewState = .expanded
                        endValue = 0
                        startValue = 0
                        occasionViewModel.showImageView = false
                        occasionViewModel.stopDragGesture = false
                    }
            }
                .allowsHitTesting(startValue > 0 ? false : true)
        }
        .opacity(showImageViewer ? 1 : 0)
    }
    
    
    private var description: some View {
        ZStack {
            if let explanation = icon.explanation, !explanation.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: "book.pages")
                            .foregroundStyle(.gray400)
                        
                        Text("Description")
                            .fontWeight(.semibold)
                    }
                    .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(icon.explanation ?? "")
                            .foregroundStyle(.gray400)
                            .fontWeight(.medium)
                            .lineLimit(descriptionHeight)

                        if icon.explanation?.count ?? 0 > 30 {
                            Button(action: {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                    descriptionHeight = (descriptionHeight == 3) ? 100 : 3
                                    HapticsManager.instance.impact(style: .soft)
                                    
                                }
                            }, label: {
                                HStack(alignment: .center, spacing: 4) {
                                    Text("See \((descriptionHeight == 3) ? "more" : "less")")
                                        .fontWeight(.semibold)
                                    Image(systemName: (descriptionHeight == 3) ? "chevron.down" : "chevron.up")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                            })
                        }
                        
                    }
                }
                .padding(.horizontal, 20)
                .textSelection(.enabled)

            }
        }

    }
    
    private var story: some View {
       
        ZStack {
            if occasionViewModel.getStory(forIcon: selectedSaint ?? icon) == nil {
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: "book")
                            .foregroundStyle(.gray400)
                        
                        Text(stories.saint ?? "")
                            .fontWeight(.semibold)
                            .lineLimit(2)
                    }
                    .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text(stories.story ?? "")
                            .foregroundStyle(.gray400)
                            .fontWeight(.medium)
                            .lineLimit(storyHeight)
                        
                        
                        Button {
                            openSheet?.toggle()
                        } label: {
                            HStack(alignment: .center, spacing: 4) {
                                Text("Read more")
                                    .fontWeight(.semibold)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                        }

                        
                        
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
                .background(.gray50)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .padding(.horizontal, 20)
            .textSelection(.enabled)

            }
        }

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
                
                Button(action: {
                    
                }, label: {
                    HStack(alignment: .center, spacing: 4) {
                        Text("Read more")
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                })

                
            }
        }
        .padding(.horizontal, 20)
        .textSelection(.enabled)

    }
    
    private var divider: some View {
        Divider()
            .background(.gray50)
    }
    
    private var fitImageView: some View {
        VStack {}
        .frame(maxWidth: .infinity)
        .frame(height: 420)
        .background(
            SaintImageView(icon: icon)
                .matchedGeometryEffect(id: "\(icon.id)", in: namespace)
                .scaledToFill()
                .transition(.scale(scale: 1))
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                        showImageViewer = true
                        occasionViewModel.showImageView = true
                        occasionViewModel.stopDragGesture = true
                        
                    }
                }
        )
        .mask({
            RoundedRectangle(cornerRadius: 24)
                .matchedGeometryEffect(id: "\(icon.image)", in: namespace)
        })
        
    }
    
    private var iconCaption: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(icon.caption ?? "")
                .font(.title2)
            .fontWeight(.semibold)
            
            if !(occasionViewModel.iconagrapher == nil) {
                Text("\(occasionViewModel.iconagrapher?.name ?? "None")")
                    .font(.callout)
                    .fontWeight(.medium)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                    .background(.primary300)
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            }
            
            
            if !((occasionViewModel.iconagrapher?.name) == nil) {
                
            }
        }
    }
}



