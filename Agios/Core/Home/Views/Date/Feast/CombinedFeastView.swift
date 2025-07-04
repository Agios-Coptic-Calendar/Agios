//
//  ContentView.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 04/07/2025.
//

import SwiftUI

struct CombinedFeastView: View {
    @ObservedObject var occasionViewModel: OccasionsViewModel
    @Binding var selectedCopticMonth: CopticMonth?
    @FocusState.Binding var isTextFieldFocused: Bool
    
    var filteredDates: [CopticMonth] {
        if occasionViewModel.searchDate.isEmpty {
            return occasionViewModel.allCopticMonths
        } else {
            return occasionViewModel.allCopticMonths.filter { date in
                date.name.lowercased().contains(occasionViewModel.searchDate.lowercased())
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
        ZStack {
            if occasionViewModel.searchDate.isEmpty {
                NavigationView(
                    occasionViewModel: occasionViewModel,
                    selectedCopticMonth: $selectedCopticMonth,
                    filteredDates: filteredDates
                )
            } else {
                SearchResultsView(
                    occasionViewModel: occasionViewModel,
                    searchedDates: searchedDatesFromAllMonths,
                    isTextFieldFocused: $isTextFieldFocused
                )
            }
        }
    }
}

#Preview {
    @FocusState var isTextFieldFocused: Bool
    CombinedFeastView(occasionViewModel: OccasionsViewModel(), selectedCopticMonth: .constant(CopticMonth(name: "Tout", dates: ["Tout 1"])), isTextFieldFocused: $isTextFieldFocused)
}
