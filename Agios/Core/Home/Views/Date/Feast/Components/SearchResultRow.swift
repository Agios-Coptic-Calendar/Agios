//
//  SearchResultRow.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 04/07/2025.
//

import SwiftUI

struct SearchResultRow: View {
    let date: String
    @ObservedObject var occasionViewModel: OccasionsViewModel
    let onTap: () -> Void
    
    var isSelected: Bool {
        occasionViewModel.datePicker == occasionViewModel.date(from: date) ?? Date() ||
        "\(occasionViewModel.newCopticDate?.month ?? "") \(occasionViewModel.newCopticDate?.day ?? "")" == date
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(date)
                    .foregroundStyle(.primary1000)
                    .fontWeight(.medium)
                
                Spacer()
                
                ZStack {
                    if isSelected {
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
                    .opacity(isSelected ? 1 : 0)
            }
            .padding(.horizontal, 16)
        }
        .buttonStyle(BouncyButton())
    }
}
