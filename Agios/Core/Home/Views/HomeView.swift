//
//  HomeView.swift
//  Agios
//
//  Created by Victor on 18/04/2024.
//

import SwiftUI
import SwiftUIX

 
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
    @State private var showImageViewer: Bool = false
    let iconographer: Iconagrapher
    
    
    var namespace: Namespace.ID
    let startingDate: Date = Calendar.current.date(from: DateComponents(year: 2018)) ?? Date()
    
    @EnvironmentObject private var occasionViewModel: OccasionsViewModel
    @EnvironmentObject private var imageViewModel: IconImageViewModel
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                ZStack(alignment: .center) {
                    if occasionViewModel.isLoading {
                        ProgressView("Loading...")
                            .frame(height: UIScreen.main.bounds.height)
                            .frame(width: UIScreen.main.bounds.width)
                    } else {
                        VStack(spacing: 40) {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 32) {
                                    VStack(spacing: 32) {
                                        illustration
                                        HStack(content: {
                                            if !occasionViewModel.copticDateTapped {
                                                dateView
                                            }
                                            Spacer()
                                            if !occasionViewModel.defaultDateTapped {
                                                copticDate
                                            }
                                            
                                        })
                                        .padding(.horizontal, 20)
                                    }
                                    fastView
                                }
                                VStack(spacing: 12) {
                                    imageView
                                        
                                    dailyQuote
                                }
                            }
                            dailyReading
                            upcomingFeasts
                        }
                        .padding(.vertical, 32)

                    }
                    
                    if occasionViewModel.copticDateTapped {
                        ZStack {
                            VisualEffectBlurView(blurStyle: .light)
                                .intensity(0.3)
                                .offset(y: -60)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                        occasionViewModel.copticDateTapped = false
                                    }
                                }
 
                            CopticDateView(namespace: namespace)
                                .offset(y: -365)
                        }
                    } else if occasionViewModel.defaultDateTapped {
                        ZStack {
                            VisualEffectBlurView(blurStyle: .light)
                                .intensity(0.3)
                                .offset(y: -60)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                        occasionViewModel.defaultDateTapped = false
                                    }
                                }
 
                            DatePickerView(namespace: namespace)
                                .offset(y: -325)
                        }
                    }
                    
                }
                //.navigationBarBackButtonHidden(false)
                .navigationBarBackButtonHidden(true)
            }
            .fontDesign(.rounded)
            .background(.primary100)
            .scrollIndicators(.hidden)
            .scrollDisabled(occasionViewModel.copticDateTapped || occasionViewModel.defaultDateTapped ? true : false)
        }
        
        
    }
    
}



struct HomeView_Preview: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        HomeView(iconographer: dev.iconagrapher, namespace: namespace)
            .environmentObject(IconImageViewModel(icon: dev.icon))
            .environmentObject(OccasionsViewModel())
            
    }
}

private var backgroundColor: some View {
    LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0.431372549, green: 0.6823632717, blue: 0.7646967769, alpha: 1)),
                                            Color(#colorLiteral(red: 0.9058917165, green: 0.8509779572, blue: 0.8588247299, alpha: 1)),
                                            Color(#colorLiteral(red: 0.9843173623, green: 0.96470505, blue: 0.9647064805, alpha: 1))]), startPoint: .top,
                   endPoint: .bottom)
    .edgesIgnoringSafeArea(.all)
}


extension HomeView {
    private var copticDate: some View {
        Button(action: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                occasionViewModel.copticDateTapped.toggle()
            }
        }, label: {
            HStack(spacing: 8) {
                Text(occasionViewModel.copticDate)
                     .font(.body)
                     .fontWeight(.semibold)
                     .frame(width: 120, alignment: .leading)
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
    
    private var dateView: some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                occasionViewModel.defaultDateTapped.toggle()
            }
        } label: {
            HStack(spacing: 8) {
                Text(datePicker.formatted(date: .abbreviated, time: .omitted))
                     .font(.body)
                     .fontWeight(.semibold)
                     .frame(width: 110, alignment: .leading)
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
    
    private var fastView: some View {
        Text("6th Week of the Great Lent.")
        //Text(occasionViewModel.dataClass?.liturgicalInformation ?? "")
            .font(.title2)
             .fontWeight(.semibold)
             .multilineTextAlignment(.leading)
             .foregroundColor(.gray900)
             //.padding(.vertical, 7)
             .padding(.horizontal, 20)
//                     .background(.primary300)
//                     .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
             //.animation(.spring(response: 0.4, dampingFraction: 0.75))
             //.onTapGesture(perform: viewModel.showLiturgicalInfo)
             //.padding(.horizontal, isFeastTapped ? 0 : 20)
    }
    
    private var imageView: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
             HStack(spacing: 24) {

                 ForEach(occasionViewModel.icons) { saint in
                     NavigationLink {
                         SaintDetailsView(icon: saint, iconographer: dev.iconagrapher, showImageViewer: $showImageViewer, selectedSaint: $selectedSaint, namespace: namespace)
                             .navigationBarBackButtonHidden(showImageViewer ? true : false)

                     } label: {
                         HomeSaintImageView(icon: saint)
                             .aspectRatio(contentMode: .fill)
                             .scrollTransition { content, phase in
                                 content
                                     .rotation3DEffect(Angle(degrees: phase.isIdentity ? 0 : -10), axis: (x: 0, y: 50, z: 0))
                                     .blur(radius: phase.isIdentity ? 0 : 2)
                                     .scaleEffect(phase.isIdentity ? 1 : 0.95)
                             }
                     }
                     
                 }
             }
             .padding(.top, -24)
             .padding(.horizontal, 24)
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
        //readings
        VStack (alignment: .leading, spacing: 24) {
            Text("Daily readings")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.gray900)
                .padding(.leading, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack (alignment: .center, spacing: 16) {
                    ForEach(occasionViewModel.readings) { reading in
                        ForEach(occasionViewModel.passages, id: \.self) { passage in
                            Button {
                                occasionViewModel.openSheet.toggle()
                                HapticsManager.instance.impact(style: .light)
                            } label: {
                                NavigationLink {
                                    ReadingsView(passage: passage, verse: dev.verses)
                                } label: {
                                    DailyReadingView(passage: passage, reading: reading)       
                                }
                            }
                            .buttonStyle(BouncyButton()) 
                            

                        }
                    }

                    
                        //.scaleEffect(selectedPresentableSection == viewModel.presentableSections[index] ? 1.1 : 1.0)
                        //.animation(.spring(response: 0.6, dampingFraction: 0.4))
                        .onTapGesture {
                            withAnimation {
                                //selectedPresentableSection = viewModel.presentableSections[index]
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation {
                                    //selectedPresentableSection = nil
                                    //presentableSection = viewModel.presentableSections[index]
                                    showReadings = true
                                }
                            }
                        }
                    }
                    .padding(.bottom, 8)
                    .padding(.horizontal, 20)
                }
                .padding(.top, -10)

//                        .halfSheet(showSheet: $showReadings) {
//                            ReadingDetailsView(section: presentableSection)
//                        } onDismiss: { self.presentableSection = nil }
            }
       
    }
    
    private var upcomingFeasts: some View {
        VStack (alignment: .leading, spacing: 24) {
            Text("Upcoming feasts")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.gray900)
                .padding(.leading, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack (alignment: .center, spacing: 16) {
                    ForEach(0..<3) { reading in
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

                    }
                    
                        //.scaleEffect(selectedPresentableSection == viewModel.presentableSections[index] ? 1.1 : 1.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.4))
                        .onTapGesture {
                            withAnimation {
                                //selectedPresentableSection = viewModel.presentableSections[index]
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation {
                                    //selectedPresentableSection = nil
                                    //presentableSection = viewModel.presentableSections[index]
                                    showReadings = true
                                }
                            }
                        }
                    }
                    .padding(.bottom, 8)
                    .padding(.leading, 20)
                }
                .padding(.top, -10)

//                        .halfSheet(showSheet: $showReadings) {
//                            ReadingDetailsView(section: presentableSection)
//                        } onDismiss: { self.presentableSection = nil }
            }
    }
    
    private var dailyQuote: some View {
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
            
            Text("'If one plans for himself, he should accept responsibility for the difficulties of the trip and on the other hand if he leaves the planning to God, God will dispose every stage of the trip.'")
                .multilineTextAlignment(.center)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.gray900)
            
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
    
    private var illustration: some View {
        VStack(alignment: .center, spacing: 24) {
            HStack {
                Spacer()
                Image("nav_illustration")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 45, alignment: .center)
                Spacer()
            }
        }
        .padding(.horizontal, 20)

    }
}

