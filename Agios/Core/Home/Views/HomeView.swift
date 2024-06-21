//
//  HomeView.swift
//  Agios
//
//  Created by Victor on 18/04/2024.
//

import SwiftUI
import Shimmer

 
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
    //@State private var selectedSaints: IconModel?
    @State private var selectedSection: SubSection?
    @State private var showImageViewer: Bool = false
    @State private var scaleImage: Bool = false
    @State private var offset: CGSize = .zero
    let iconographer: Iconagrapher
    @State private var selection: Int = 1
    @State private var showStory: Bool = false
    
    
    
    var namespace: Namespace.ID
    var transition: Namespace.ID
    
    
    @EnvironmentObject private var occasionViewModel: OccasionsViewModel
    @EnvironmentObject private var imageViewModel: IconImageViewModel
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 40) {
                        VStack(spacing: 28) {
                            VStack(alignment: .leading, spacing: 32) {
                                VStack(spacing: 32) {
                                    illustration
                                    VStack(spacing: 16) {
                                        fastView
                                        combinedDateView
                                        
                                    }
                                }
                            }
                            VStack(spacing: 20) {
                                imageView
                                DailyQuoteView(fact: dev.fact)
                            }
                        }
                        dailyReading
                        upcomingFeasts
                    }
                    .padding(.vertical, 32)
                    .transition(.scale(scale: 0.95, anchor: .top))
                    .transition(.opacity)    
                }
                .scrollIndicators(.hidden)
                .scrollDisabled(occasionViewModel.copticDateTapped || occasionViewModel.defaultDateTapped || occasionViewModel.isLoading ? true : false)
                .refreshable {
                    occasionViewModel.getPosts()
                }
                
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                            occasionViewModel.defaultDateTapped = false
                            occasionViewModel.searchDate = ""
                        }
                    }
                    .opacity(occasionViewModel.defaultDateTapped ? 1 : 0)
                
             if occasionViewModel.defaultDateTapped {
                 DateView(namespace: namespace)
                }
            }
            .fontDesign(.rounded)
            .background(.primary100)
            
        }
        .fullScreenCover(isPresented: $occasionViewModel.showStory, content: {
            StoryDetailView(story: occasionViewModel.getStory(forIcon: selectedSaint ?? dev.icon) ?? dev.story)
        })
        
        
        
    
    }
    
    private func getScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.height / 2
        let currentAmount = abs(offset.height)
        let percentage = currentAmount / max
        let scaleAmount = 1.0 - min(percentage, 0.5) * 0.5
                 
        return scaleAmount
    }
    
}



struct HomeView_Preview: PreviewProvider {
    
    @Namespace static var namespace
    @Namespace static var transition
    
    static var previews: some View {
        HomeView(iconographer: dev.iconagrapher, namespace: namespace, transition: transition)
            .environmentObject(OccasionsViewModel())
            .environmentObject(IconImageViewModel(icon: dev.icon))
            
             
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
                    //HapticsManager.instance.impact(style: .light)
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                        occasionViewModel.defaultDateTapped.toggle()
                    }
                }, label: {
                    HStack(alignment: .center, spacing: 8, content: {
                        Text(occasionViewModel.datePicker.formatted(date: .abbreviated, time: .omitted))
                            .lineLimit(1)
                            .foregroundStyle(.primary1000)
                            .fontWeight(.medium)
                            //.matchedGeometryEffect(id: "regularDate", in: namespace)
                        
                        Rectangle()
                            .fill(.primary600)
                            .frame(width: 1, height: 17)
                            //.matchedGeometryEffect(id: "divider", in: namespace)
                        
                        HStack(spacing: 4) {
                            Text("\(occasionViewModel.newCopticDate?.month ?? "") \(occasionViewModel.newCopticDate?.day ?? "")")
                                .lineLimit(1)
                                .foregroundStyle(.primary1000)
                                .frame(width: 100)
                                //.matchedGeometryEffect(id: "copticDate", in: namespace)
                                
                            
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
                            //.matchedGeometryEffect(id: "background", in: namespace)
                    )
                    .mask({
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            //.matchedGeometryEffect(id: "mask", in: namespace)
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
                Text(occasionViewModel.feast)
                    .font(.title2)
                     .fontWeight(.semibold)
                     .multilineTextAlignment(.center)
                     .foregroundColor(.primary1000)
                     .frame(width: 250)
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
                    HStack(spacing: -28) {
                        if !occasionViewModel.filteredIcons.isEmpty {
                            NavigationLink {
                                SaintGroupDetailsView(
                                    icon: selectedSaint ?? dev.icon,
                                    iconographer: dev.iconagrapher,
                                    stories: occasionViewModel.getStory(forIcon: occasionViewModel.filteredIcons.first ?? dev.icon) ?? dev.story,
                                    showImageViewer: $showImageViewer,
                                    selectedSaints: $selectedSaint, namespace: namespace)
                                .environmentObject(occasionViewModel)
                                .environmentObject(ImageViewerViewModel())
                                .environmentObject(IconImageViewModel(icon: selectedSaint ?? dev.icon))
                                .navigationBarBackButtonHidden(true)
                                //.navigationTransition(.zoom(sourceID: "saint", in: transition))
                            } label: {
                                GroupedSaintImageView(selectedSaint: $selectedSaint, showStory: $occasionViewModel.showStory)
                                    
                                    .environmentObject(occasionViewModel)
                                    .environmentObject(ImageViewerViewModel())
                                    .environmentObject(IconImageViewModel(icon: selectedSaint ?? dev.icon))
                                    .frame(width: 320, height: 430, alignment: .leading)
                                    
                            }
                            //.matchedTransitionSource(id: "saint", in: transition)

                        }
                        
                        ForEach(occasionViewModel.icons) { saint in
                            NavigationLink {
                                SaintDetailsView(
                                    icon: saint,
                                    iconographer: occasionViewModel.iconagrapher ?? dev.iconagrapher,
                                    stories: occasionViewModel.getStory(forIcon: selectedSaint ?? dev.icon) ?? dev.story,
                                    showImageViewer: $showImageViewer,
                                    selectedSaint: $selectedSaint,
                                    namespace: namespace
                                )
                                
                                .environmentObject(occasionViewModel)
                                .environmentObject(IconImageViewModel(icon: saint))
                                .environmentObject(ImageViewerViewModel())
                                .navigationBarBackButtonHidden(true)
                                //.navigationTransition(.zoom(sourceID: "\(saint.id)", in: transition))
                            } label: {
                                HomeSaintImageView(icon: saint)
                                    .aspectRatio(contentMode: .fill)
                                    .scrollTransition { content, phase in
                                        content
                                            .rotation3DEffect(Angle(degrees: phase.isIdentity ? 0 : -10), axis: (x: 0, y: 50, z: 0))
                                            .blur(radius: phase.isIdentity ? 0 : 2)
                                            .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                    }
                                    .contextMenu(ContextMenu(menuItems: {
                                        Button {
                                            occasionViewModel.showStory.toggle()
                                            selectedSaint = saint
                                        } label: {
                                            if occasionViewModel.getStory(forIcon: saint) != nil {
                                                Label("See story", systemImage: "book")
                                            } else {
                                                Text("No story")
                                            }
                                        }
                                        .disabled((occasionViewModel.getStory(forIcon: saint) != nil) == true ? false : true)
                                    }))
                                    
                                    .frame(height: 430)
                                    .frame(width: 350)
                                    //.matchedTransitionSource(id: "\(saint.id)", in: transition)

                                    
                            }
                            .animation(.spring(response: 0.5, dampingFraction: 0.6))
                            .simultaneousGesture(
                                TapGesture().onEnded {
                                    selectedSaint = saint
                                }
                            )
                        }
                    }
                    .padding(.top, -24)
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
                         ForEach(occasionViewModel.readings) { reading in
                             ForEach(occasionViewModel.passages, id: \.self) { passage in
                                 ForEach(occasionViewModel.subSection) { subSection in
                                     NavigationLink {
                                         ReadingsView(passage: passage, verse: dev.verses, subSection: subSection)
                                     } label: {
                                         DailyReadingView(passage: passage, reading: reading, subSection: subSection)
                                             
                                     }
                                     //.scaleEffect(selectedSection == subSection ? 1.1 : 1.0)
                                     .animation(.spring(response: 1, dampingFraction: 0.6))
                                     .simultaneousGesture(TapGesture().onEnded{
                                         withAnimation(.easeIn(duration: 0.1)) {
                                             selectedSection = subSection
                                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                 selectedSection = nil
                                                 
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
                    ForEach(0..<3) { reading in
                        if occasionViewModel.isLoading {
                            ShimmerView(heightSize: 150, cornerRadius: 24)
                                .frame(width: 260)
                                .transition(.opacity)
                        } else {
                            VStack(alignment: .leading, spacing: 32, content: {
                                Text("Upcoming feast that takes two lines of text.")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.gray900)
                                    .frame(width: 260, alignment: .leading)
                                
                                Text("In 2 days")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundStyle(.gray700)
                            })
                            .padding(16)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .modifier(TapToScaleModifier())
                        }

                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 8)
                .padding(.leading, 20)
            }
        }
    }
    
    private var illustration: some View {
        VStack(alignment: .center, spacing: 24) {
            HStack {
                Spacer()
                Image("illustration")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 360, height: 54)
                Spacer()
            }
        }
        .frame(maxWidth: 400)
    }
    
    private var dailyQuote: some View {
        ZStack {
           if occasionViewModel.isLoading {
                ShimmerView(heightSize: 250, cornerRadius: 24)
                   .padding(.horizontal, 20)
           } else {
               if ((occasionViewModel.fact?.isEmpty) != nil) {
                   VStack(alignment: .center, spacing: 16) {
                       HStack(alignment: .center, spacing: 8, content: {
                           Image("single_leaf")
                               .resizable()
                               .renderingMode(.template)
                               .frame(width: 40, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                               .foregroundStyle(.primary900)
                           
                           Text("Daily Quote".uppercased())
                               .foregroundStyle(.gray900)
                               .fontWeight(.semibold)
                               .font(.callout)
                               .kerning(1.3)
                           
                           Image("single_leaf")
                               .resizable()
                               .renderingMode(.template)
                               .frame(width: 40, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                               .foregroundStyle(.primary900)
                               .rotation3DEffect(
                                   .degrees(180),
                                   axis: (x: 0.0, y: 1.0, z: 0.0)
                               )

                       })
                       
//                           Text(fact.fact ?? "Fact is empty.")
//                               .multilineTextAlignment(.center)
//                               .font(.title3)
//                               .fontWeight(.semibold)
//                               .foregroundStyle(.gray900)
//                               .textSelection(.enabled)
                       
                       
                       Text("by fr pishoy kamel".uppercased())
                           .foregroundStyle(.gray900)
                           .fontWeight(.semibold)
                           .font(.callout)
                           .kerning(1.3)
                   }
                   .padding(.vertical, 24)
                   .padding(.horizontal, 16)
                   .background(.primary200)
                   .clipShape(RoundedRectangle(cornerRadius: 24, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                   .overlay(content: {
                       RoundedRectangle(cornerRadius: 24, style: .continuous)
                           .stroke(.primary900, style: StrokeStyle(lineWidth: 1, dash: [10,5], dashPhase: 3), antialiased: false)
                   })
                   .padding(.horizontal, 20)
               }
              
           }
        }
    }
}

