//
//  ShimmerView.swift
//  Agios
//
//  Created by Victor on 5/2/24.
//

import SwiftUI
import Shimmer

struct ShimmerView: View {
    @State var heightSize: Double
    @State var cornerRadius: Double
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.primary300)
            .frame(height: heightSize)
            .shimmering()
    }
}

#Preview {
    ShimmerView(heightSize: 30, cornerRadius: 40)
}
