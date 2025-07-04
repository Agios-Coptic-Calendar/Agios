//
//  YearSelector.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 04/07/2025.
//

import SwiftUI

struct YearSelector: View {
    @ObservedObject var occasionViewModel: OccasionsViewModel
    
    var body: some View {
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
    }
}

#Preview {
    YearSelector(occasionViewModel: OccasionsViewModel())
}
