//
//  MonthRow.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 04/07/2025.
//

import SwiftUI

struct MonthRow: View {
    let month: CopticMonth
    @ObservedObject var occasionViewModel: OccasionsViewModel
    let onTap: () -> Void
    
    var isSelected: Bool {
        occasionViewModel.selectedCopticMonth?.id == month.id && occasionViewModel.setColor ||
        "\(occasionViewModel.newCopticDate?.month ?? "")" == month.name
    }
    
    var isHighlighted: Bool {
        occasionViewModel.datePicker == occasionViewModel.date(from: month.name) ?? Date()
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(month.name)
                    .foregroundStyle(.primary1000)
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(.primary1000)
                        .frame(width: 6, height: 6)
                        .opacity(isSelected ? 1 : 0)
                    
                    Text("\(month.dates.count) days")
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
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.primary1000, lineWidth: 0.7)
                    .opacity(isHighlighted ? 1 : 0)
            }
        }
        .buttonStyle(BouncyButton())
        .padding(.horizontal, 16)
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .trailing)
        ))
    }
}
