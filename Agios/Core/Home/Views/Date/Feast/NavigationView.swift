//
//  NavigationView.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 04/07/2025.
//

import SwiftUI

struct NavigationView: View {
    @ObservedObject var occasionViewModel: OccasionsViewModel
    @Binding var selectedCopticMonth: CopticMonth?
    let filteredDates: [CopticMonth]
    
    var body: some View {
        ZStack {
            if selectedCopticMonth == nil {
                MonthListView(
                    occasionViewModel: occasionViewModel,
                    selectedCopticMonth: $selectedCopticMonth,
                    filteredDates: filteredDates
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            } else {
                DateListView(
                    occasionViewModel: occasionViewModel,
                    selectedCopticMonth: $selectedCopticMonth
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
        }
    }
}
