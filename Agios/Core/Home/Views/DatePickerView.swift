//
//  DatePickerView.swift
//  Agios
//
//  Created by Victor on 4/25/24.
//

import SwiftUI

struct DatePickerView: View {
    @EnvironmentObject private var occasionViewModel: OccasionsViewModel
    var namespace: Namespace.ID
    @State private var openCopticList: Bool = false
    @State private var datePicker: Date = Date()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    Image(systemName: "xmark")
                        .fontWeight(.medium)
                        .frame(width: 60, height: 30, alignment: .leading)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                occasionViewModel.defaultDateTapped = false
                            }
                            HapticsManager.instance.impact(style: .light)
                        }
                    
                    Spacer()
                    
                    Text(datePicker.formatted(date: .abbreviated, time: .omitted))
                        .lineLimit(1)
                        .frame(width: 120, alignment: .leading)
                        .matchedGeometryEffect(id: "defaultDate", in: namespace)
                    
                    Spacer()
                    
                    Text("Set")
                        .fontWeight(.medium)
                        .foregroundStyle(.primary900)
                        .frame(width: 30, height: 30)
                        .padding(.horizontal)
                        .background(.primary200)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .onTapGesture {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                occasionViewModel.defaultDateTapped = false
                            }
                            HapticsManager.instance.impact(style: .light)
                        }
                }
                .padding(.vertical, 12)
                
                VStack(alignment: .center, spacing: 0) {
                    Divider()
                        .background(.gray50)
                    
                    
                    
                    ScrollView {
                        DatePicker(selection: $datePicker, displayedComponents: [.date]) {
                            
                        }
                        //.colorMultiply(colorScheme == .dark ? .black : .white)
                        .datePickerStyle(.graphical)
                        .environment(\.colorScheme, .light)
                        
                    }
                    .scrollIndicators(.hidden)
                    
                }
                .scaleEffect(openCopticList ? 1 : 0.3, anchor: .topLeading)
                
            }
            .padding(.horizontal, 16)
            .foregroundStyle(.gray900)
            .fontWeight(.medium)
            .fontDesign(.rounded)
//            .onChange(of: datePicker, { oldValue, newValue in
//                withAnimation(.spring(response: 0.35, dampingFraction: 0.88)) {
//                    occasionViewModel.defaultDateTapped = false
//                    
//                }
//                HapticsManager.instance.impact(style: .light)
//            })
            
            
        Rectangle()
                .fill(.linearGradient(colors: [.white, .clear], startPoint: .bottom, endPoint: .top))
                .frame(height: 60)
            
        }
        .frame(height: 380)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white)
                .matchedGeometryEffect(id: "dateBackground", in: namespace)
        )
        .mask({
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .matchedGeometryEffect(id: "maskDate", in: namespace)
        })
        .padding(.horizontal, 20)
        .onAppear(perform: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                openCopticList = true
            }
        })
    }
}

struct DatePickerView_Preview: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        DatePickerView(namespace: namespace)
            .environmentObject(OccasionsViewModel())
    }
}
