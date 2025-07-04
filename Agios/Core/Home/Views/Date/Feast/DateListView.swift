//
//  DateListView.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 04/07/2025.
//

import SwiftUI

struct DateListView: View {
    @ObservedObject var occasionViewModel: OccasionsViewModel
    @Binding var selectedCopticMonth: CopticMonth?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            BackButton(
                monthName: selectedCopticMonth?.name ?? "",
                onTap: {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                        selectedCopticMonth = nil
                        occasionViewModel.setColor = false
                    }
                }
            )
            
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(selectedCopticMonth?.dates ?? [], id: \.self) { date in
                        DateRow(
                            date: date,
                            occasionViewModel: occasionViewModel,
                            onTap: {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                    occasionViewModel.copticDateTapped = false
                                    let processedDate = date.contains("Baounah") ? 
                                        date.replacingOccurrences(of: "Baounah", with: "Paona") : date
                                    occasionViewModel.datePicker = occasionViewModel.date(from: processedDate) ?? Date()
                                    
                                    if occasionViewModel.datePicker == occasionViewModel.date(from: processedDate) ?? Date() {
                                        occasionViewModel.setColor = true
                                    }
                                    
                                    print("selected date \(date)")
                                }
                                HapticsManager.instance.impact(style: .light)
                            }
                        )
                    }
                }
                .foregroundStyle(.primary1000)
                .padding(.vertical, 8)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.top, 12)
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        ))
    }
}

#Preview {
    DateListView(occasionViewModel: OccasionsViewModel(), selectedCopticMonth: .constant(CopticMonth(name: "Tout", dates: ["Tout 1"])))
}
