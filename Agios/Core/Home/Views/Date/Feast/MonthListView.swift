//
//  MonthListView.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 04/07/2025.
//

import SwiftUI

struct MonthListView: View {
    @ObservedObject var occasionViewModel: OccasionsViewModel
    @Binding var selectedCopticMonth: CopticMonth?
    let filteredDates: [CopticMonth]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            YearSelector(occasionViewModel: occasionViewModel)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(filteredDates) { date in
                        MonthRow(
                            month: date,
                            occasionViewModel: occasionViewModel,
                            onTap: {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                                    selectedCopticMonth = date
                                    selectedCopticMonth?.id = date.id
                                    occasionViewModel.selectedCopticMonth = date
                                    occasionViewModel.selectedCopticMonth?.id = date.id
                                    print("selected month \(date.name)")
                                }
                            }
                        )
                    }
                }
                .foregroundStyle(.primary1000)
                .padding(.vertical, 8)
                .padding(.bottom, 30)
                .padding(.top, 4)
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    MonthListView(occasionViewModel: OccasionsViewModel(), selectedCopticMonth: .constant(CopticMonth(name: "Tout", dates: ["Tout 1"])) , filteredDates: [CopticMonth(name: "Tout 1", dates: ["Tout 1"])])
}
