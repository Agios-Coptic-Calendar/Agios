//
//  BackButton.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 04/07/2025.
//

import SwiftUI

struct BackButton: View {
    let monthName: String
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "chevron.left")
                .font(.caption)
            
            Text(monthName)
                .foregroundStyle(.primary1000)
        }
        .padding(.horizontal, 16)
        .onTapGesture(perform: onTap)
    }
}
