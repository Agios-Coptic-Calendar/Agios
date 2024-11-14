//
//  HomeView.swift
//  Agios
//
//  Created by Victor on 18/04/2024.
//


import SwiftUI
import Shimmer
import Popovers
import WidgetKit

enum DragPhase {
    case initial
    case unrestricted
}

 
struct HomeView: View {
    @State private var tapNategaPlus = false
    @State private var showSynaxars: Bool? = false
    @State private var showReadings: Bool = false
    @State private var tapIcon = false
    @State private var imageTapped = false
    @State private var readingTapped = false
    @State private var isFeastTapped:Bool = false
    @State private var datePicker: Date = .now
    @State private var selectedSaint: IconModel?
    @State private var selectedIcon: IconModel? = nil
    @State private var upcomingFeast: IconModel? = nil
    @State private var showDetailedView: Bool = false
    @State private var showGDView: Bool = false
    @State private var selectedSection: Passage?
    @State private var showImageViewer: Bool = false
    @State private var scaleImage: Bool = false
    @State private var offset: CGSize = .zero
    @State private var selection: Int = 1
    @State private var showStory: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var startValue: CGFloat = 0
    @State private var currentScale: CGFloat = 1.0
    @State private var position: CGSize = .zero
    @State private var hapticsTriggered = false
    @State private var dragPhase: DragPhase = .initial
    
    @State private var selectedReading: DataReading?
    @State private var selectedReadingForAnimation: DataReading?
    @State private var selectedLiturgy: SubSection?
    @State private var selectedSubsection: SubSection?
    @State private var presentedReadingSheet: Bool? = false
    @State private var navigateToDateView: Bool = false
    
    var namespace: Namespace.ID
    var transition: Namespace.ID
    
    
    @EnvironmentObject private var occasionViewModel: OccasionsViewModel
    @EnvironmentObject private var iconImageViewModel: IconImageViewModel
    @EnvironmentObject private var imageViewModel: IconImageViewModel
    @State private var showEventNotLoaded = false
    
    var body: some View {
        
        NavigationStack {
            ZStack(alignment: .bottom) {
                ZStack {
                    ZStack {
                        Color.primary100.ignoresSafeArea()
                        ScrollView {
                            VStack(spacing: 40) {
                                VStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 32) {
                                        VStack(spacing: 18) {
                                            illustration
                                            VStack(spacing: 18) {
                                                fastView
                                                combinedDateView
                                            }
                                        }
                                    }
                                    VStack(spacing: 18) {
                                        imageView
                                        DailyQuoteView(viewModel: occasionViewModel.dailyQuotesViewModel,
                                                       isLoading: occasionViewModel.isLoading)
                                    }
                                }
                                dailyReading
                                upcomingFeasts
                            }
                            .padding(.bottom, 48)
                            .padding(.top, 48)
                            .transition(.scale(scale: 0.95, anchor: .top))
                            .transition(.opacity)
                            
                            
                        }
                        .padding(.top, 40)
                        .refreshable {
                            withAnimation {
                                occasionViewModel.isLoading = true
                            }
                            await Task.sleep(2 * 1_000_000_000) // Delay for 2 seconds
                            occasionViewModel.datePicker = Date()
                            occasionViewModel.getPosts()
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                        .allowsHitTesting(occasionViewModel.disallowTapping ? false : true)
                        .scrollIndicators(.hidden)
                        //.scrollDisabled(occasionViewModel.copticDateTapped || occasionViewModel.defaultDateTapped || occasionViewModel.isLoading ? true : false)
                        .scaleEffect(occasionViewModel.defaultDateTapped || occasionViewModel.viewState == .expanded || occasionViewModel.viewState == .imageView ? 0.98 : 1)
                        .blur(radius: occasionViewModel.defaultDateTapped || occasionViewModel.viewState == .expanded || occasionViewModel.viewState == .imageView ? 3 : 0)
                        
                        
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                    occasionViewModel.defaultDateTapped = false
                                    occasionViewModel.searchDate = ""
                                    occasionViewModel.searchText = false
                                    occasionViewModel.isTextFieldFocused = false
                                    occasionViewModel.hideKeyboard()
                                }
                            }
                            .opacity(occasionViewModel.defaultDateTapped  ? 1 : 0)
                        
                    }
                    .fontDesign(.rounded)
                    
                    ZStack {
                        if occasionViewModel.defaultDateTapped {
                            DateView(transition: transition)
                                .offset(y: -keyboardHeight/2.4)
                            //.transition(.blurReplace)
                        }
                    }
                    
                    
                    // This controls switching between the home view and single saint / icon details views.
                    ZStack {
                        switch occasionViewModel.viewState {
                        case .expanded:
                            DetailLoadingView(icon: $selectedIcon, story: occasionViewModel.getStory(forIcon: selectedIcon ?? dev.icon) ?? dev.story, namespace: namespace)
                            //.transition(.opacity)
                            //.transition(.scale(scale: 1))
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
                                    !occasionViewModel.stopDragGesture ?
                                    DragGesture()
                                        .onChanged { value in
                                            let dragThreshold: CGFloat = 100
                                            
                                            switch dragPhase {
                                            case .initial:
                                                if abs(value.translation.width) > abs(value.translation.height) && value.translation.width > 0 {
                                                    // Initial phase: restrict to left-to-right dragging
                                                    withAnimation {
                                                        offset = CGSize(width: value.translation.width, height: .zero)
                                                    }
                                                    
                                                    if abs(value.translation.width) > dragThreshold {
                                                        dragPhase = .unrestricted
                                                        HapticsManager.instance.impact(style: .light)
                                                        hapticsTriggered = true
                                                    }
                                                }
                                            case .unrestricted:
                                                // Unrestricted phase: allow dragging in all directions
                                                withAnimation {
                                                    offset = value.translation
                                                }
                                                
                                                if !hapticsTriggered && (abs(value.translation.width) > dragThreshold || abs(value.translation.height) > dragThreshold) {
                                                    HapticsManager.instance.impact(style: .light)
                                                    hapticsTriggered = true
                                                }
                                            }
                                        }
                                        .onEnded { value in
                                            let dragThreshold: CGFloat = 100
                                            
                                            switch dragPhase {
                                            case .initial:
                                                if value.translation.width > 0 && abs(value.translation.width) > dragThreshold {
                                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                                        occasionViewModel.viewState = .collapsed
                                                        offset = .zero
                                                        selectedSaint = nil
                                                        occasionViewModel.selectedSaint = nil
                                                    }
                                                    occasionViewModel.disallowTapping = true
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.62) {
                                                        occasionViewModel.disallowTapping = false
                                                    }
                                                } else {
                                                    withAnimation(.spring(response: 0.35, dampingFraction: 1)) {
                                                        offset = .zero
                                                    }
                                                }
                                            case .unrestricted:
                                                if abs(value.translation.width) > dragThreshold || abs(value.translation.height) > dragThreshold {
                                                    withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                                        occasionViewModel.viewState = .collapsed
                                                        offset = .zero
                                                        selectedSaint = nil
                                                        occasionViewModel.selectedSaint = nil
                                                    }
                                                    occasionViewModel.disallowTapping = true
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.62) {
                                                        occasionViewModel.disallowTapping = false
                                                    }
                                                } else {
                                                    withAnimation(.spring(response: 0.35, dampingFraction: 1)) {
                                                        offset = .zero
                                                    }
                                                }
                                            }
                                            
                                            // Reset the drag phase and haptics triggered state after dragging ends
                                            dragPhase = .initial
                                            hapticsTriggered = false
                                        }
                                    : nil
                                )
                            
                                .environmentObject(occasionViewModel)
                            
                        case .collapsed:
                            EmptyView()
                        case .imageView:
                            GroupedDetailLoadingView(icon: selectedSaint, story: occasionViewModel.getStory(forIcon: occasionViewModel.filteredIcons.first ?? dev.icon) ?? dev.story, selectedSaint: $selectedSaint, namespace: namespace)
                            //.transition(.blurReplace)
                                .transition(.scale(scale: 1))
                                .environmentObject(occasionViewModel)
                        }
                    }
                    //.transition(.opacity)
                    
                    Rectangle()
                        .fill(.gray900.opacity(0.3))
                        .opacity(occasionViewModel.showUpcomingView || (occasionViewModel.showEventNotLoaded && !iconImageViewModel.isLoading && occasionViewModel.isLoading) ? 1 : 0)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                occasionViewModel.showUpcomingView = false
                            }
                        }
                }
                //.ignoresSafeArea(edges: .all)
                
                // Pop up for when data doesn't load in view
                ZStack {
                    if occasionViewModel.showEventNotLoaded && !iconImageViewModel.isLoading && occasionViewModel.isLoading {
                        eventNotLoaded
                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                    }
                    
                }
                
                // Upcoming feast modal
                ZStack {
                    if occasionViewModel.showUpcomingView {
                        UpcomingFeastView()
                            .padding(.horizontal, 20)
                            .padding(.bottom, 48)
                            .environmentObject(occasionViewModel)
                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                    }
                    
                }
                
            }
            .ignoresSafeArea(edges: .all)
  
        }
        .onChange(of: occasionViewModel.datePicker) { _, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.95)) {
                    occasionViewModel.showEventNotLoaded = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.95)) {
                    navigateToDateView = false
                }
            }
            
        }
        
        // This controls the keyboard appearance on the search text field in the date picker in a custom way.
        .onAppear {
            occasionViewModel.stopDragGesture = false
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    withAnimation(.spring(response: 0.45, dampingFraction: 1)) {
                        keyboardHeight = keyboardFrame.height
                    }
                }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                withAnimation(.spring(response: 0.32, dampingFraction: 1)) {
                    keyboardHeight = 0
                }
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        .halfSheet(showSheet: $occasionViewModel.showStory) {
            StoryDetailView(story: (occasionViewModel.getStory(forIcon: occasionViewModel.selectedGroupIcons.first ?? dev.icon) ?? occasionViewModel.selectedStory) ?? dev.story)
                .environmentObject(occasionViewModel)
        } onDismiss: {
            selectedSaint = nil
            selectedIcon = nil
        }
    }
    
    private func getScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.height / 2
        let currentAmount = abs(offset.width)
        let percentage = currentAmount / max
        let scaleAmount = 1.0 - min(percentage, 0.5) * 0.6
                 
        return scaleAmount
    }
    
    private func segue(icon: IconModel) {
        selectedIcon = icon
        showDetailedView.toggle()
    }
    
    private func gdSegue(icon: IconModel) {
        selectedSaint = icon
        showGDView.toggle()
    }
    
}



struct HomeView_Preview: PreviewProvider {
    
    @Namespace static var namespace
    @Namespace static var transition
    
    static var previews: some View {
        HeroWrapper {
            HomeView(namespace: namespace, transition: transition)
                .environmentObject(OccasionsViewModel())
                .environmentObject(IconImageViewModel(icon: dev.icon))
        }
    }
}

extension HomeView {
    private var combinedDateView: some View {
        ZStack {
            if occasionViewModel.isLoading {
                ShimmerView(heightSize: 32, cornerRadius: 24)
                    .transition(.opacity)
                    .frame(width: 200)
            } else {
                Button(action: {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                        occasionViewModel.defaultDateTapped.toggle()
                    }
                }, label: {
                    HStack(alignment: .center, spacing: 8, content: {
                        Text(occasionViewModel.datePicker.formatted(date: .abbreviated, time: .omitted))
                            .lineLimit(1)
                            .foregroundStyle(.primary1000)
                            .fontWeight(.medium)
                        
                        Rectangle()
                            .fill(.primary600)
                            .frame(width: 1, height: 17)
                        
                        HStack(spacing: 4) {
                            Text("\(occasionViewModel.newCopticDate?.month ?? "") \(occasionViewModel.newCopticDate?.day ?? "")")
                                .lineLimit(1)
                                .foregroundStyle(.primary1000)
                                .multilineTextAlignment(.leading)
                                
                            
                            Image(systemName: "chevron.down")
                                .font(.caption2)
                                .foregroundStyle(.primary500)
                        }
                        .fontWeight(.medium)
                        
                        
                    })
                    .padding(.vertical, 6)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.primary300)
                            .matchedGeometryEffect(id: "background", in: transition)
                    )
                    .mask({
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .matchedGeometryEffect(id: "mask", in: transition)
                    })

                })

            }
        }
    }
    private var copticDate: some View {
        ZStack {
            if occasionViewModel.isLoading {
                ShimmerView(heightSize: 32, cornerRadius: 24)
                    .transition(.opacity)
            } else {
                Button(action: {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                        occasionViewModel.copticDateTapped.toggle()
                    }
                }, label: {
                    HStack(spacing: 8) {
                        Text(occasionViewModel.copticDate)
                             .font(.body)
                             .fontWeight(.semibold)
                             .frame(maxWidth: .infinity, alignment: .leading)
                             .lineLimit(1)
                             .matchedGeometryEffect(id: "copticDate", in: namespace)
                        
                        Image(systemName: "chevron.down")
                            .fontWeight(.semibold)
                            .font(.caption)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.primary300)
                            .matchedGeometryEffect(id: "background", in: namespace)
                    )
                    .mask({
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .matchedGeometryEffect(id: "mask", in: namespace)
                    })

                })
                .foregroundColor(.gray900)
            }
        }

    }
    
    private var dateView: some View {
        ZStack {
            if occasionViewModel.isLoading {
                ShimmerView(heightSize: 32, cornerRadius: 24)
                    .transition(.opacity)
            } else {
                Button {
                    withAnimation(.spring(response: 0.30, dampingFraction: 0.88)) {
                        occasionViewModel.defaultDateTapped.toggle()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text(datePicker.formatted(date: .abbreviated, time: .omitted))
                             .font(.body)
                             .fontWeight(.semibold)
                             .frame(width: 117, alignment: .leading)
                             .lineLimit(1)
                             .matchedGeometryEffect(id: "defaultDate", in: namespace)
                        
                        Image(systemName: "chevron.down")
                            .fontWeight(.semibold)
                            .font(.caption)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.primary300)
                            .matchedGeometryEffect(id: "dateBackground", in: namespace)
                    )
                    .mask({
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .matchedGeometryEffect(id: "maskDate", in: namespace)
                    })

                }
                 .foregroundColor(.gray900)

            }
        }

         

    }
    
    private var fastView: some View {
        ZStack {
            if occasionViewModel.isLoading {
                ShimmerView(heightSize: 54, cornerRadius: 24)
                    .transition(.opacity)
                    .frame(width: 250)
                
            } else {
                ZStack {
                    if occasionViewModel.liturgicalInfoTapped {
                        Text(occasionViewModel.liturgicalInformation ?? "No Liturgical Info")
                            .transition(.blurReplace(.downUp))
                    } else {
                        Text(occasionViewModel.feast)
                            .transition(.blurReplace(.downUp))
                    }
                }
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary1000)
                .frame(width: 250)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        occasionViewModel.liturgicalInfoTapped.toggle()
                        HapticsManager.instance.impact(style: .soft)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        
    }
    
    private var imageView: some View {
        ZStack {
            if occasionViewModel.isLoading {
                ScrollView(.horizontal) {
                    HStack(spacing: 18) {
                        ForEach(0..<2) { index in
                            ShimmerView(heightSize: 350, cornerRadius: 24)
                                .frame(width: 300, alignment: .leading)
                                .transition(.opacity)
                                .padding(.vertical, 25)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .scrollDisabled(true)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(occasionViewModel.icons) { saint in
                            //HomeSaintImageView(namespace: namespace, icon: saint)
//                            CardView(icon: saint,
//                                     iconographer: occasionViewModel.iconagrapher ?? dev.iconagrapher,
//                                     stories: occasionViewModel.getStory(forIcon: saint) ?? dev.story,
//                                     showImageViewer: $showImageViewer,
//                                     selectedSaint: $selectedSaint,
//                                     namespace: namespace)
//                                .contextMenu(ContextMenu(menuItems: {
//                                    Button {
//                                        occasionViewModel.showStory?.toggle()
//                                        selectedIcon = saint
//                                        selectedSaint = saint
//                                    } label: {
//                                        if occasionViewModel.getStory(forIcon: saint) != nil {
//                                            Label("See story", systemImage: "book")
//                                        } else {
//                                            Text("No story")
//                                        }
//                                    }
//                                    .disabled((occasionViewModel.getStory(forIcon: saint) != nil) == true ? false : true)
//                                }))
//                                .allowsHitTesting(occasionViewModel.disallowTapping ? false : true)
//                                .scrollTransition { content, phase in
//                                    content
//                                        .rotation3DEffect(Angle(degrees: phase.isIdentity ? 0 : -10), axis: (x: 0, y: 50, z: 0))
//                                        .blur(radius: phase.isIdentity ? 0 : 0.9)
//                                        .scaleEffect(phase.isIdentity ? 1 : 0.95)
//                                }
//                                
//                                .frame(height: 400, alignment: .center)
//                                .onTapGesture {
//                                    segue(icon: saint)
//                                    selectedSaint = saint
//                                    occasionViewModel.disallowTapping = true
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                                        occasionViewModel.disallowTapping = false
//                                    }
//                                    withAnimation(.spring(response: 0.25, dampingFraction: 1)) {
//                                        occasionViewModel.viewState = .expanded
//                                        occasionViewModel.selectedSaint = saint
//                                    }
//                                    
//                                }
//                                .opacity(occasionViewModel.selectedSaint == saint ? 0 : 1)
                            
                        }
//                         if occasionViewModel.filteredIcons.isEmpty {
//                            // GroupedSaintImageView(selectedSaint: $selectedSaint, showStory: $occasionViewModel.showStory, namespace: namespace)
//                         }
                        
                        if !occasionViewModel.filteredIconsGroups.isEmpty {
                            AllGroupedIconsView(namespace: namespace)
                                .scrollTransition { content, phase in
                                    content
                                        .rotation3DEffect(Angle(degrees: phase.isIdentity ? 0 : -10), axis: (x: 0, y: 50, z: 0))
                                        .blur(radius: phase.isIdentity ? 0 : 0.9)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                }
                                .frame(height: 400, alignment: .center)
                        }
                        if !occasionViewModel.storiesWithoutIcons.isEmpty {
                            StoriesWithoutIconsView(namespace: namespace)
                                .background(.clear)
                                .frame(height: 400, alignment: .center)

                        }
                    }
                    //.padding(.top, -24)
                    .padding(.horizontal, 24)
                }
                
            }
        }
    }

    
    private var commemorations: some View {
        ZStack {
            if occasionViewModel.isLoading {
                ProgressView()
                    .padding(16)
                    .lineLimit(6)
                    .background(.lightBlue.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .padding(.bottom, 40)
                    .padding(.horizontal, 16)
            } else {
                VStack(alignment: .leading, spacing: 16) {
                     Text("Commemorations")
                         .font(.system(size: 20, weight: .bold, design: .rounded))
                         .foregroundColor(.black)
                         .padding(.horizontal, 16)
                     HStack(spacing: 16) {
                         if occasionViewModel.readings.isEmpty {
                             // Add an empty view or placeholder here
                             Text("As today is a Major Feast of the Lord, the Synaxarium is not read today.")
                                 .padding(.bottom, 5)
                                 .padding(.horizontal, 16)
                         } else {
                             TabView {
                                 ForEach(occasionViewModel.stories) { story in
                                     Text("\(story.story ?? "")")
                                         .padding(16)
                                         .lineLimit(6)
                                         .background(.white)
                                         .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                                         //.scaleEffect(selectedCommemoration == reading ? 1.05 : 1.0)
                                         //.animation(.spring(response: 0.6, dampingFraction: 0.4))
                                         .onTapGesture {
                                             withAnimation() {
                                                 //selectedCommemoration = reading
                                             }
                                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                 withAnimation {
                                                     //selectedCommemoration = nil
                                                     //self.reading = reading
                                                     showSynaxars = true
                                                 }
                                             }
                                         }
                                         .padding(.bottom, 40)
                                         .padding(.horizontal, 16)
                                 }
                             }
                             .frame(height: 200)

                         }
                     }
                     .multilineTextAlignment(.center)
                     .font(.title3)
                     .tabViewStyle(.page)
                 }
                .foregroundColor(.black)
            }
        }

    }
    
    
    private var dailyReading: some View {
        VStack (alignment: .leading, spacing: 8) {
            ZStack {
                if occasionViewModel.isLoading {
                    ShimmerView(heightSize: 26, cornerRadius: 24)
                        .frame(width: 160)
                        .transition(.opacity)
                } else {
                    Text("Daily readings")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray900)
                }
            }
            .padding(.leading, 20)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (alignment: .center, spacing: 16) {
                    if occasionViewModel.isLoading {
                        ForEach(0..<5) { index in
                            ShimmerView(heightSize: 80, cornerRadius: 24)
                                .frame(width: 160)
                                .transition(.opacity)
                        }
                    } else {
                        HStack {
                            ForEach(occasionViewModel.readings) { reading in
                                ReadingView(reading: reading)
                                    .onTapGesture {
                                        selectedLiturgy = nil
                                        selectedReading = reading
                                        presentedReadingSheet = true
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .scaleEffect(selectedReadingForAnimation == reading ? 1.1 : 1.0)
                                    .simultaneousGesture(TapGesture().onEnded{
                                        withAnimation(.easeIn(duration: 0.1)) {
                                            selectedReadingForAnimation = reading
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                selectedReadingForAnimation = nil
                                            }
                                        }
                                    })
                                    .halfSheet(showSheet: $presentedReadingSheet) {
                                        if let selectedReading {
                                            ReadingsView(reading: selectedReading,
                                                         subsectionTitle: selectedReading.subSections?.first?.title ?? "")
                                            //.presentationDragIndicator(.visible)
                                        }
                                        if let selectedLiturgy {
                                            LiturgyReadingDetailsView(subsection: selectedLiturgy)
                                                //.presentationDetents([.medium, .large])
                                                //.presentationDragIndicator(.visible)
                                        }
                                    } onDismiss: {
                                        //selectedSaint = nil
                                       // selectedIcon = nil
                                    }
//                                    .sheet(isPresented: $presentedReadingSheet) {
//                                       
//                                    }
                                    //.animation(.spring(), value: selectedReadingForAnimation)
                                    //.scaleEffect(selectedReadingForAnimation == reading ? 1.1 : 1.0)
                                    

                            }
                            if let liturgy = occasionViewModel.liturgy {
                                ForEach(liturgy.subSections ?? []) { subsection in
                                        SubsectionView(mainReadingTitle: liturgy.title ?? "",
                                                       subsection: subsection)
                                        .padding(16)
                                        .background(liturgy.color(for: subsection.id ?? 0).gradient)
                                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .onTapGesture {
                                            selectedReading = nil
                                            selectedLiturgy = subsection
                                            presentedReadingSheet = true
                                        }
                                    .scaleEffect(selectedSubsection == subsection ? 1.1 : 1.0)
                                    .simultaneousGesture(TapGesture().onEnded{
                                        withAnimation(.easeIn(duration: 0.1)) {
                                            selectedSubsection = subsection
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                selectedSubsection = nil
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 8)
                .padding(.horizontal, 20)
            }
        }

    }
     

    
    private var upcomingFeasts: some View {
        VStack (alignment: .leading, spacing: 8) {
            ZStack {
                if occasionViewModel.isLoading {
                    ShimmerView(heightSize: 32, cornerRadius: 24)
                        .frame(width: 160)
                        .transition(.opacity)
                } else {
                    Text("Upcoming feasts")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray900)
                }
            }
            .padding(.leading, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack (alignment: .center, spacing: 16) {
                    ForEach(0..<3) { saint in
                        if occasionViewModel.isLoading {
                            ShimmerView(heightSize: 150, cornerRadius: 24)
                                .frame(width: 260)
                                .transition(.opacity)
                        } else {
                            HStack(spacing: 16) {
                                Rectangle()
                                    .fill(.primary200)
                                    .frame(width: 80, height: 87, alignment: .center)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                VStack(alignment: .leading, spacing: 16, content: {
                                    Text("St. Joseph Father of Emmanuel")
                                        .font(.title3)
                                        .lineLimit(2)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.gray900)
                                        .frame(width: 200, alignment: .leading)
                                    
                                    Text("In 2 days")
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.gray700)
                                })
                            }
                            .padding(16)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .onTapGesture {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                    occasionViewModel.showUpcomingView = true
                                }
                            }
                            .modifier(TapToScaleModifier())
                        }

                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 8)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            }

            
        }
    }
    
    private var illustration: some View {
        VStack(alignment: .center, spacing: 24) {
            ZStack {
                Image("crest")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 46.25, height: 47.5)
                    .offset(y: -17)
                    .opacity(occasionViewModel.showCrest ? 1 : 0)
                    .blur(radius: occasionViewModel.showCrest ? 0 : 5)
                
                Image("details")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 355, height: 76.26)
            }
        }
        .frame(maxWidth: 400)
    }
    
    private var eventNotLoaded: some View {
        ZStack {
            if !navigateToDateView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Oops, we couldn’t get the event for this day.")
                            .font(.title3)
                            .foregroundStyle(.gray900)
                            .fontWeight(.semibold)
                        
                        Text("This could be due to slow internet connection or server maintenance. Feel free to try again or select a new date.")
                            .font(.body)
                            .foregroundStyle(.gray600)
                            .fontWeight(.medium)
                    }
                    
                    HStack(spacing: 8) {
                        Text("Try again")
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .background(.primary900)
                            .foregroundStyle(.gray50)
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                            .onTapGesture {
                                //occasionViewModel.filterDate()
                                occasionViewModel.getPosts()
                                
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.95)) {
                                    occasionViewModel.showEventNotLoaded = false
                                }
                                HapticsManager.instance.impact(style: .soft)
                            }
                        
                        
                        HStack(spacing: 8) {
                            Text("Select a date")
                                .foregroundStyle(.primary1000)
                            
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.primary900)
                                .padding(.vertical, 7)
                                .padding(.horizontal, 7)
                                .background(.primary200)
                                .clipShape(Circle())
                            
                        }
                        .padding(.vertical, 7)
                        .padding(.leading, 16)
                        .padding(.trailing, 12)
                        .overlay {
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(.primary400, lineWidth: 0.7)
                        }
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.95)) {
                                navigateToDateView.toggle()
                            }
                        }
                    }
                    .fontWeight(.medium)
                }
                .fontDesign(.rounded)
                .kerning(-0.4)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
            } else {
                VStack(alignment: .center, spacing: 8) {
                    Text("Select a date")
                        .fontWeight(.medium)
                        .padding(.top, 18)
                        .padding(.bottom, 9)
                    
                    Divider()
                        .background(.gray50)
                    
                    NormalDateView()
                        .environmentObject(occasionViewModel)
                        .padding(.top, -12)
                }
                .overlay(alignment: .topLeading, content: {
                    NavigationButton(labelName: .back, backgroundColor: .primary200, foregroundColor: .primary900)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.95)) {
                                navigateToDateView = false
                            }
                        }
                })
                .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .trailing).combined(with: .opacity)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white)
        )
        .mask({
            RoundedRectangle(cornerRadius: 24, style: .continuous)
        })
        .padding(.bottom, 48)
        .padding(.horizontal, 20)
        .frame(maxWidth: 500)
        
        
    }
    
}
