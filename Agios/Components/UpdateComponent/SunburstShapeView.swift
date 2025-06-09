//
//  SunburstShapeView.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 09/06/2025.
//


import SwiftUI

import SwiftUI

struct SunBeamView: View {
    let color: Color
    var body: some View {
        ZStack {
            ForEach(0..<13) { index in
                Rectangle()
                    .fill(color)
                    .frame(width: 25)
                    .offset(y: -40)
                    .rotationEffect(.degrees(Double(index) * 30))
            }
        }
    }
}


#Preview {
    SunBeamView(color: .blue)
}
