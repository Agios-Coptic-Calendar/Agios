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
    
    init(occasionViewModel: OccasionsViewModel) {
        self.occasionViewModel = occasionViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            SearchBar(
                searchText: $occasionViewModel.searchDate,
                isTextFieldFocused: $isTextFieldFocused,
                onTap: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                        occasionViewModel.searchText = true
                        isTextFieldFocused.toggle()
                    }
                }
            )
            
            CombinedFeastView(
                occasionViewModel: occasionViewModel,
                selectedCopticMonth: $selectedCopticMonth,
                isTextFieldFocused: $isTextFieldFocused
            )
            .frame(height: selectedCopticMonth != nil ? 290 : 250, alignment: .top)
        }
    }
}

#Preview {
    FeastView(occasionViewModel: OccasionsViewModel())
}
