//
//  DateView.swift
//  Agios
//
//  Created by Victor on 5/15/24.
//

import SwiftUI
import Lottie

struct DateView: View {
    enum DateSelection: Int, CaseIterable {
       case regularDate
       case feast
       case yearAhead
           
       func title(using viewModel: OccasionsViewModel) -> String {
           switch self {
           case .regularDate:
               return "\(viewModel.datePicker.formatDateShort(viewModel.datePicker))"
           case .feast:
                   return "\(viewModel.setCopticDate?.month ?? "") \(viewModel.setCopticDate?.day ?? "")"
           case .yearAhead:
               return "Year ahead"
           }
       }
       
       @ViewBuilder
       func selectedDate(using viewModel: OccasionsViewModel) -> some View {
           switch self {
           case .regularDate:
                   NormalDateView(vm: viewModel)
           case .feast:
                   FeastView(occasionViewModel: viewModel)
           case .yearAhead:
                   YearAheadView(occasionViewModel: viewModel)
           }
       }
   }
    
    @ObservedObject private var occasionViewModel: OccasionsViewModel
    var transition: Namespace.ID
    @State private var openCopticList: Bool = false
    @State private var datePicker: Date = Date()
    @Environment(\.colorScheme) var colorScheme
    @State private var searchText: Bool = false
    @State private var datedTapped: Bool = false
    @State private var feastTapped: Bool = false
    @State private var yearTapped: Bool = false
    let startingDate: Date = Calendar.current.date(from: DateComponents(year: 2023)) ?? Date()
    
    init(occasionViewModel: OccasionsViewModel, transition: Namespace.ID) {
        self.occasionViewModel = occasionViewModel
        self.transition = transition
    }
    @AppStorage("animationModeKey") private var animationsMode: DateSelection = .regularDate
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Text("Select a date")
                            .fontWeight(.medium)
                            
                    }
                    
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
                                        occasionViewModel.hideKeyboard()
                                    }
                                    
                                } label: {
                                    Text(mode.title(using: occasionViewModel))
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
                    
                    animationsMode.selectedDate(using: occasionViewModel)
                                            .transition(.opacity.combined(with: .scale(scale: 0.94, anchor: .bottom)).animation(.spring(response: 0.3, dampingFraction: 1)))
                    
                }
                .scaleEffect(openCopticList ? 1 : 0.85, anchor: .top)
                .blur(radius: openCopticList ? 0 : 15)
                .opacity(openCopticList ? 1 : 0)
                .animation(.spring(response: 0.4, dampingFraction: 1), value: animationsMode)
            }
            .foregroundStyle(.gray900)
            .fontWeight(.medium)
            .fontDesign(.rounded)
        }
        
        .overlay(alignment: .topLeading) {
            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                    occasionViewModel.defaultDateTapped = false
                    occasionViewModel.searchDate = ""
                    occasionViewModel.searchText = false
                    occasionViewModel.hideKeyboard()
                }
                //HapticsManager.instance.impact(style: .light)
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
                .matchedGeometryEffect(id: "background", in: transition)
        )
        .mask({
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .matchedGeometryEffect(id: "mask", in: transition)
        })
        .padding(.horizontal, 20)
        .onAppear(perform: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                openCopticList = true
            }
            occasionViewModel.filteredDate = occasionViewModel.mockDates
        })
        .onDisappear(perform: {
           
                openCopticList = false

        })
        
        .onChange(of: occasionViewModel.datePicker) { _, _ in
            occasionViewModel.filterDate()
            HapticsManager.instance.impact(style: .light)
        }
        .environment(\.colorScheme, .light)
        .fontDesign(.rounded)
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: animationsMode)
        .frame(maxWidth: 400)
    }
    
}

struct NormalDateView: View {
    @ObservedObject private var vm: OccasionsViewModel
    
    init(vm: OccasionsViewModel) {
        self.vm = vm
    }
    var body: some View {
        DatePicker("", selection: $vm.datePicker,
                   in: AppEnvironment.dateRange,
                   displayedComponents: [.date])
        .datePickerStyle(.graphical)
        .environment(\.colorScheme, .light)
        .padding(.horizontal, 16)
        .frame(height: 336, alignment: .top)
        .frame(maxWidth: 350)
        
    }
}
