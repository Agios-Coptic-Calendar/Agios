//
//  FeastView.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 29/06/2025.
//

import SwiftUI
import Lottie

struct FeastView: View {
    @ObservedObject private var occasionViewModel: OccasionsViewModel
    
    @FocusState private var isTextFieldFocused: Bool
    @State private var selectedCopticMonth: CopticMonth? = nil
    @State private var selectedYear: String = ""

    
    init(occasionViewModel: OccasionsViewModel) {
        self.occasionViewModel = occasionViewModel
    }
    
    var filteredDates: [CopticMonth] {
        if occasionViewModel.searchDate.isEmpty {
            return occasionViewModel.allCopticMonths
        } else {
            return occasionViewModel.allCopticMonths.filter { date in

                return date.name.lowercased().contains(occasionViewModel.searchDate.lowercased())
            }
        }
    }
    
    var searchedDatesFromAllMonths: [String] {
        let dataSource = !occasionViewModel.allCopticMonths.isEmpty ? occasionViewModel.allCopticMonths : filteredDates
        
        let allDates = dataSource.flatMap { month in
            month.dates.map { date in
                "\(date)"
            }
        }
        
        if occasionViewModel.searchDate.isEmpty {
            return allDates
        } else {
            let searchTerm = occasionViewModel.searchDate.trimmingCharacters(in: .whitespacesAndNewlines)
            return allDates.filter { dateString in
                return dateString.lowercased().contains(searchTerm.lowercased())
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.callout)
                    .foregroundStyle(isTextFieldFocused ? .primary900 : .gray200)
                
                
                TextField("Search", text: $occasionViewModel.searchDate)
                    .foregroundStyle(.gray900)
                    .frame(maxWidth: .infinity)
                    .submitLabel(.search)
                    .focused($isTextFieldFocused)
            }
            .fontWeight(.medium)
            .foregroundStyle(.gray300)
            .padding(.horizontal, 8)
            .padding(.vertical, 9)
            .background(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 32)
                    .stroke(isTextFieldFocused ? .primary900 : .gray200, lineWidth: 1)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                    occasionViewModel.searchText = true
                    isTextFieldFocused.toggle()
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            
                ZStack {
                    if occasionViewModel.searchDate.isEmpty {
                        ZStack {
                            ZStack {
                                if selectedCopticMonth == nil {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Menu {
                                            ForEach(occasionViewModel.availableCopticYears, id: \.self) { year in
                                                Button(action: {
                                                    withBouncySpringAnimation {
                                                        occasionViewModel.onSelectYear(year)
                                                    }
                                                    
                                                }) {
                                                    Text(year)
                                                }
                                            }
                                        } label: {
                                            HStack {
                                                Text("Year \(occasionViewModel.selectedCopticYear)")
                                                    .foregroundStyle(.primary1000)
                                                
                                                Image(systemName: "chevron.right")
                                                    .font(.caption)
                                                    .foregroundStyle(.primary700)
                                            }
                                            .padding(.horizontal, 16)
                                            .padding(.top, 16)
                                            .fontWeight(.medium)
                                        }
                                        ScrollView {
                                            VStack(alignment: .leading, spacing: 8) {
                                                ForEach(filteredDates) { date in
                                                    Button(action: {
                       
                                                        withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                                            selectedCopticMonth = date
                                                            selectedCopticMonth?.id = date.id
                                                            occasionViewModel.selectedCopticMonth = date
                                                            occasionViewModel.selectedCopticMonth?.id = date.id
                                                            print("selected month \(date.name)")

                                                        }
                                                    }, label: {
                                                        HStack {
                                                            Text(date.name)
                                                                .foregroundStyle(.primary1000)
                                                                .lineLimit(1)
                                                            
                                                            Spacer()
                                                            
                                                            HStack(spacing: 8) {
                                                                
                                                                Circle()
                                                                    .fill(.primary1000)
                                                                    .frame(width: 6, height: 6)
                                                                    .opacity(occasionViewModel.selectedCopticMonth?.id == date.id && occasionViewModel.setColor || "\(occasionViewModel.newCopticDate?.month ?? "")" == date.name ? 1 : 0)
                                                                   
                                                                Text("\(date.dates.count) days")
                                                                    .foregroundStyle(.primary1000)
                                                                    .opacity(0.5)

                                                                Image(systemName: "chevron.right")
                                                                    .font(.caption2)
                                                                    .foregroundStyle(.primary500)
                                                            }
                                                            
                                                        }
                                                        .fontWeight(.medium)
                                                        .padding(.vertical, 9)
                                                        .padding(.horizontal, 16)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .background(.primary100)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                                .stroke(Color.primary1000, lineWidth: 0.7)
                                                                .opacity((occasionViewModel.datePicker == occasionViewModel.date(from: date.name) ?? Date()) ? 1 : 0)
                                                        }
                                                    })
                                                    .buttonStyle(BouncyButton())
                                                    .padding(.horizontal, 16)
                                                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .trailing)))
                                                }

                                                
                                            }
                                            .foregroundStyle(.primary1000)
                                            .padding(.vertical, 8)
                                            .padding(.bottom, 30)
                                            .padding(.top, 4)
                                        }
                                        .scrollIndicators(.hidden)
                                    }
                                    .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
                                }

                            }

                            
                            ZStack {
                                if selectedCopticMonth != nil {
                                    VStack(alignment: .leading, spacing: 12) {
                                        
                                        HStack(spacing: 8) {
                                            Image(systemName: "chevron.left")
                                                .font(.caption)
                                            
                                            Text(selectedCopticMonth?.name ?? "")
                                                .foregroundStyle(.primary1000)
                                        }
                                        .padding(.horizontal, 16)
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                                selectedCopticMonth = nil
                                                occasionViewModel.setColor = false
                                            }
                                        }
                                        
                                        ScrollView {
                                            VStack(spacing: 8) {
                                                ForEach(selectedCopticMonth?.dates ?? [], id: \.self) { date in
                                                    Button {
                                                        withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                                            occasionViewModel.copticDateTapped = false
                                                            if date.contains("Baounah") {
                                                                let paona = date.replacingOccurrences(of: "Baounah", with: "Paona")
                                                                occasionViewModel.datePicker = occasionViewModel.date(from: paona) ?? Date()
                                                                isTextFieldFocused = false
                                                            } else {
                                                                occasionViewModel.datePicker = occasionViewModel.date(from: date) ?? Date()
                                                                isTextFieldFocused = false

                                                            }
                                                            
                                                            if (occasionViewModel.datePicker == occasionViewModel.date(from: date) ?? Date()) {
                                                                occasionViewModel.setColor = true
                                                            }
                                                            
                                                            print("selected date \(date)")
                                                            
                                                        }
                                                        HapticsManager.instance.impact(style: .light)
                                                    } label: {
                                                        HStack {
                                                            Text(date)
                                                                .foregroundStyle(.primary1000)
                                                                .fontWeight(.medium)
                                                                
                                                            Spacer()
                                                            ZStack {
                                                                if date.contains("Baounah") {
                                                                    let paona = date.replacingOccurrences(of: "Baounah", with: "Paona")
                                                                    if occasionViewModel.datePicker == occasionViewModel.date(from: paona) ?? Date() || "\(occasionViewModel.newCopticDate?.month ?? "") \(occasionViewModel.newCopticDate?.day ?? "")" == date {
                                                                        Image(systemName: "checkmark.circle.fill")
                                                                            .transition(.scale)
                                                                    }
                                                                } else if occasionViewModel.datePicker == occasionViewModel.date(from: date) ?? Date() || "\(occasionViewModel.newCopticDate?.month ?? "") \(occasionViewModel.newCopticDate?.day ?? "")" == date {
                                                                    Image(systemName: "checkmark.circle.fill")
                                                                        .transition(.scale)
                                                                }
                                                            }
                                                        }
                                                        .padding(.vertical, 9)
                                                        .padding(.horizontal, 16)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .background(.primary100)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                                .stroke(Color.primary1000, lineWidth: 0.7)
                                                                .opacity({
                                                                    if date.contains("Baounah") {
                                                                        let paona = date.replacingOccurrences(of: "Baounah", with: "Paona")
                                                                        return (occasionViewModel.datePicker == occasionViewModel.date(from: paona) ?? Date() || "\(occasionViewModel.newCopticDate?.month ?? "") \(occasionViewModel.newCopticDate?.day ?? "")" == date) ? 1 : 0
                                                                    } else {
                                                                        return (occasionViewModel.datePicker == occasionViewModel.date(from: date) ?? Date() || "\(occasionViewModel.newCopticDate?.month ?? "") \(occasionViewModel.newCopticDate?.day ?? "")" == date) ? 1 : 0
                                                                    }
                                                                }())
                                                        }
                                                        .padding(.horizontal, 16)
                                                    }
                                                    .buttonStyle(BouncyButton())
                                                }
                                            }
                                            .foregroundStyle(.primary1000)
                                            .padding(.vertical, 8)
                                            .padding(.bottom, 30)
                                        }
                                        .scrollIndicators(.hidden)
                                    }
                                    .padding(.top, 12)
                                    .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))

                                }
                            }
                            .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))

                        }
                    } else {
                        ZStack {
                            if searchedDatesFromAllMonths.isEmpty {
                                VStack(spacing: -8, content: {
                                    LottieView(animation: .named("search-a.json"))
                                        .playbackMode(.playing(.toProgress(1, loopMode: .loop)))
                                        .frame(width: 80, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .rotationEffect(Angle(degrees: -90))
                                    Text("No results founds")
                                        .fontWeight(.medium)
                                        .fontDesign(.rounded)
                                        .foregroundStyle(.primary600)
                                        .padding(.vertical, 20)
                                         
                                })
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                            } else {
                                VStack(spacing: 8) {
                                    ForEach(searchedDatesFromAllMonths, id: \.self) { date in
                                        Button {
                                            withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                                occasionViewModel.copticDateTapped = false
                                                occasionViewModel.datePicker = occasionViewModel.date(from: date) ?? Date()
                                                isTextFieldFocused = false
                                            }
                                            HapticsManager.instance.impact(style: .light)
                                        } label: {
                                            HStack {
                                                Text(date)
                                                    .foregroundStyle(.primary1000)
                                                    .fontWeight(.medium)
                                                    
                                                Spacer()
                                                ZStack {
                                                    if occasionViewModel.datePicker == occasionViewModel.date(from: date) ?? Date() || "\(occasionViewModel.newCopticDate?.month ?? "") \(occasionViewModel.newCopticDate?.day ?? "")" == date {
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .transition(.scale)
                                                    }
                                                }
                                            }
                                            .padding(.vertical, 9)
                                            .padding(.horizontal, 16)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(.primary100)
                                            .clipShape(RoundedRectangle(cornerRadius: 12, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                    .stroke(Color.primary1000, lineWidth: 0.7)
                                                    .opacity(occasionViewModel.datePicker == occasionViewModel.date(from: date) ?? Date() || "\(occasionViewModel.newCopticDate?.month ?? "") \(occasionViewModel.newCopticDate?.day ?? "")" == date ? 1 : 0)
                                            }
                                            .padding(.horizontal, 16)


                                        }
                                        .buttonStyle(BouncyButton())




                                    }
                                }
                                .foregroundStyle(.primary1000)
                                .padding(.vertical, 8)
                                .padding(.bottom, 30)
                                .padding(.top, 4)

                            }
                        }
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))

                        
                    }
                }
            .frame(height: selectedCopticMonth != nil ? 290 : 250, alignment: .top)
        }
    }
}

#Preview {
    FeastView(occasionViewModel: OccasionsViewModel())
}
