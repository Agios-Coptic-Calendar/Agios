//
//  GroupedSaintImageView.swift
//  Agios
//
//  Created by Victor on 6/9/24.
//

import SwiftUI

struct GroupedSaintImageView: View {
    @EnvironmentObject private var vm: OccasionsViewModel
    var body: some View {
        ZStack {
            ForEach(Array(vm.filteredIcons.enumerated()), id: \.element.id) { index, icon in
                let reversedIndex = vm.filteredIcons.count - index - 1
                HomeSaintImageView(icon: icon)
                    .offset(y: CGFloat(reversedIndex) * -40)
                    .scaleEffect(1 - (CGFloat(reversedIndex) * 0.15))
                
            }
        }
    }
}

#Preview {
    GroupedSaintImageView()
        .environmentObject(OccasionsViewModel())
}

