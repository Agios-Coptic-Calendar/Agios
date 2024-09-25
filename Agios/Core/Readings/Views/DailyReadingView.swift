//
//  DailyReadingView.swift
//  Agios
//
//  Created by Victor on 4/26/24.
//

import SwiftUI

struct DailyReadingView: View {
    let passage: Passage
    let reading: DataReading
    let subSection: SubSection
    @State private var isTapped: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(passage.bookTranslation ?? "")  \(passage.ref ?? "")")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.gray900)
            
            HStack(alignment: .center, spacing: 4) {
                Text(subSection.title ?? "")
                
                Circle()
                    .frame(width: 4, height: 4, alignment: .center)
                
                Text(reading.title ?? "")
            }
            .font(.body)
            .fontWeight(.medium)
            .foregroundStyle(.gray900)
        }
        .padding(16)
        .background(reading.color.gradient)  // Use the computed color property
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}


#Preview {
    DailyReadingView(passage: dev.passages, reading: dev.reading, subSection: dev.subSection)
}
