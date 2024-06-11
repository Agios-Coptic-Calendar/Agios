//
//  DateView.swift
//  Agios
//
//  Created by Victor on 5/15/24.
//

import SwiftUI

struct DateView: View {
    
    enum DateSelection: Int, CaseIterable {
    case regularDate
    case feast
    case yearAhead
        
        var title: String {
            switch self {
            case .regularDate:
                return "Date"
            case .feast:
                return "Feast"
            case .yearAhead:
                return "Year ahead"
            }
        }
        
        @ViewBuilder
        var selectedDate: any View {
            switch self {
            case .regularDate:
                NormalDateView()
            case .feast:
                FeastView()
            case .yearAhead:
                YearAheadView()
            }
        }
    }
    
    @EnvironmentObject private var occasionViewModel: OccasionsViewModel
    var namespace: Namespace.ID
    @State private var openCopticList: Bool = false
    @State private var datePicker: Date = Date()
    @Environment(\.colorScheme) var colorScheme
    @State private var searchText: Bool = false
    @State private var datedTapped: Bool = false
    @State private var feastTapped: Bool = false
    @State private var yearTapped: Bool = false
    
    @AppStorage("animationModeKey") private var animationsMode: DateSelection = .regularDate
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Text(datePicker.formatted(date: .abbreviated, time: .omitted))
                            .lineLimit(1)
                            .matchedGeometryEffect(id: "regularDate", in: namespace)

                            //.frame(width: 120, alignment: .leading)
                            
                        
                        Rectangle()
                            .fill(.gray900)
                            .frame(width: 1, height: 17)
                            .matchedGeometryEffect(id: "divider", in: namespace)
                        
                        Text("\(occasionViewModel.newCopticDate?.month ?? "") \(occasionViewModel.newCopticDate?.day ?? "")")
                            .lineLimit(1)
                            .foregroundStyle(.gray900)
                            .frame(width: 100)
                            .matchedGeometryEffect(id: "copticDate", in: namespace)
                            //.frame(width: 120, alignment: .leading)
                            
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    
                    
                    
                }
                .padding(.vertical, 14)
                
                VStack(alignment: .center, spacing: 0) {
                    Divider()
                        .background(.gray50)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ForEach(DateSelection.allCases.indices, id: \.self) { index in
                                let mode = DateSelection.allCases[index]

                                Button {
                                    withAnimation {
                                        animationsMode = mode
                                    }
                                    
                                } label: {
                                    Text(mode.title)
                                        .foregroundStyle(animationsMode == mode ? .gray900 : .gray400.opacity(0.7))
                                        .font(.body)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(BouncyButton())
                                
                            }
                        }
                        Divider()
                    }

                    .frame(maxWidth: .infinity)
                    .background {
                        GeometryReader { proxy in
                            let caseCount = DateSelection.allCases.count
                            Rectangle()
                                .fill(.gray900)
                                .frame(height: 1.5)
                                .padding(.top, 40)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(width: proxy.size.width / CGFloat(caseCount))
                                // Offset the background horizontally based on the selected animation mode
                                .offset(x: proxy.size.width / CGFloat(caseCount) * CGFloat(animationsMode.rawValue))
                        }
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.9), value: animationsMode)
                    
                    AnyView(animationsMode.selectedDate)
                        .transition(.opacity.combined(with: .scale(scale: 0.94, anchor: .bottom)).animation(.spring(response: 0.3, dampingFraction: 1)))
                    
                }
                .scaleEffect(openCopticList ? 1 : 0.85, anchor: .top)
                .blur(radius: openCopticList ? 0 : 15)
                .opacity(openCopticList ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.85), value: animationsMode)
            }
            //.padding(.horizontal, 16)
            .foregroundStyle(.gray900)
            .fontWeight(.medium)
            .fontDesign(.rounded) 
            
            // Gradient
            /*
             Rectangle()
                     .fill(.linearGradient(colors: [.white, .clear], startPoint: .bottom, endPoint: .top))
                     .frame(height: 40)
             */
        
            
        }
        
        .overlay(alignment: .topLeading) {
            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                    occasionViewModel.defaultDateTapped = false
                }
                HapticsManager.instance.impact(style: .light)
            } label: {
                Image(systemName: "xmark")
                    .fontWeight(.medium)
                    .frame(width: 30, height: 30)
                    .opacity(openCopticList ? 1 : 0)
                    .blur(radius: openCopticList ? 0 : 6)
                    .foregroundStyle(.gray900)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
            }

           
        }
        
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white)
                .matchedGeometryEffect(id: "background", in: namespace)
        )
        .mask({
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .matchedGeometryEffect(id: "mask", in: namespace)
        })
        .padding(.horizontal, 20)
        .onAppear(perform: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                openCopticList = true
            }
        })
        .onDisappear(perform: {
           
                openCopticList = false

        })
        .environment(\.colorScheme, .light)
        .fontDesign(.rounded)
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: animationsMode)
        .frame(maxWidth: 400)
        .padding(.bottom, 8)
    }
}

struct DateView_Preview: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        DateView(namespace: namespace)
            .environmentObject(OccasionsViewModel())
    }
}

struct NormalDateView: View {
    @State private var datePicker: Date = Date()
    var body: some View {
        DatePicker(selection: $datePicker, in: .now..., displayedComponents: [.date]) {
            
        }
        .datePickerStyle(.graphical)
        .environment(\.colorScheme, .light)
        .padding(.horizontal, 16)
        .frame(height: 336, alignment: .top)
        .frame(maxWidth: 350)
    }
}

struct FeastView: View {
    @EnvironmentObject private var occasionViewModel: OccasionsViewModel
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(occasionViewModel.mockDates) { date in
                    Button(action: {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                            occasionViewModel.copticDateTapped = false
                            occasionViewModel.selectedCopticDate = date
                            occasionViewModel.defaultDateTapped = false
                            print("\(String(describing: occasionViewModel.selectedCopticDate?.urlLink))")
                            occasionViewModel.isLoading = true
                            occasionViewModel.getPosts()
                        }
                        HapticsManager.instance.impact(style: .light)
                        
                    }, label: {
                        //Text("\(occasionViewModel.newCopticDate?.month ?? "") \(occasionViewModel.newCopticDate?.day ?? "")")
                        Text("\(date.month) \(date.day)")
                            .padding(.vertical, 9)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.primary100)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    })
                    .buttonStyle(BouncyButton())
                    .padding(.horizontal, 16)
                }
                
            }
            .foregroundStyle(.primary1000)
            .padding(.vertical, 8)
            .padding(.bottom, 30)
            .padding(.top, 4)
        }
        .scrollIndicators(.hidden)
        .frame(height: 250, alignment: .top)
    }
}

struct YearAheadView: View {
    @EnvironmentObject private var occasionViewModel: OccasionsViewModel
    @State private var searchText: Bool = false
    @State private var datePicker: Date = Date()
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.callout)
                    .foregroundStyle(searchText ? .primary900 : .gray200)
                
                
                TextField("Search", text: $occasionViewModel.searchDate)
                    .foregroundStyle(.gray900)
                    .frame(maxWidth: .infinity)
                    .submitLabel(.search)
            }
            .fontWeight(.medium)
            .foregroundStyle(.gray300)
            .padding(.horizontal, 8)
            .padding(.vertical, 9)
            .overlay {
                RoundedRectangle(cornerRadius: 32)
                    .stroke(searchText ? .primary900 : .gray200, lineWidth: 1)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                    searchText = true
                }
            }
            .padding(.horizontal, 16)
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(0..<10) { copticDate in
                        Button(action: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                occasionViewModel.copticDateTapped = false
                                searchText = false
                            }
                            HapticsManager.instance.impact(style: .light)
                            
                        }, label: {
                            HStack {
                                Text("\(occasionViewModel.newCopticDate?.month ?? "") \(occasionViewModel.newCopticDate?.day ?? "")")
                                    .foregroundStyle(.primary1000)
                                Spacer()
                                Text(datePicker.formatted(date: .long, time: .omitted))
                                    .foregroundStyle(.primary1000.opacity(0.7))
                                    .lineLimit(1)
                                
                            }
                            .fontWeight(.medium)
                            .padding(.vertical, 9)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.primary100)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                        })
                        .buttonStyle(BouncyButton())
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 8)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
            .frame(height: 250, alignment: .top)

        }
        .padding(.top, 12)
        

    }
}
