
//
//  ReadingsView.swift
//  Agios
//
//  Created by Victor on 18/04/2024.
//

import SwiftUI

struct ReadingsView: View {
    
    let reading: DataReading
    let subsectionTitle: String
    let subSectionIndex: Int?
    let subReadingIndex: Int?
    @ObservedObject private var occasionViewModel: OccasionsViewModel
    
    init(
        reading: DataReading,
        subsectionTitle: String,
        occasionViewModel: OccasionsViewModel,
        subSectionIndex: Int? = nil,
        subReadingIndex: Int? = nil
    ) {
        self.reading = reading
        self.subsectionTitle = subsectionTitle
        self.occasionViewModel = occasionViewModel
        self.subSectionIndex = subSectionIndex
        self.subReadingIndex = subReadingIndex
    }

    private var selectedSubSection: SubSection? {
        let subSections = reading.subSections ?? []

        if let subSectionIndex,
           subSections.indices.contains(subSectionIndex) {
            return subSections[subSectionIndex]
        }

        let normalizedTitle = normalize(subsectionTitle)
        return subSections.first { normalize($0.title) == normalizedTitle } ?? subSections.first
    }

    private var selectedReadings: [SubSectionReading] {
        guard let selectedSubSection else { return [] }
        let readings = selectedSubSection.readings ?? []

        if let subReadingIndex,
           readings.indices.contains(subReadingIndex) {
            return [readings[subReadingIndex]]
        }

        return readings
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            
            Rectangle()
                .fill(LinearGradient(colors: [.primary300, .clear], startPoint: .top, endPoint: .bottom))
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .frame(width: 40, height: 5)
                    .foregroundColor(.primary400)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        HStack {
                            if let title = reading.title {
                                Text(title)
                            }
                            Spacer()
                            Text(subsectionTitle)
                        }
                        .foregroundStyle(.gray900)
                        .font(.title2)
                        .fontWeight(.semibold)
                        VStack(alignment: .leading, spacing: 32) {
                            
                            if let selectedSubSection {
                                if let introduction = selectedSubSection.introduction {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Text("INTRODUCTION")
                                                .foregroundStyle(.gray900.opacity(0.6))
                                                .fontWeight(.semibold)
                                                .font(.callout)
                                                .kerning(1.3)
                                            Spacer()
                                        }

                                        Text(introduction)
                                            .fontWeight(.medium)
                                            .font(.title3)
                                            .foregroundStyle(.gray900)
                                    }
                                    .fontWeight(.medium)
                                    .padding(20)
                                    .background(.primary200)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                }
                                   
                                ForEach(Array(selectedReadings.enumerated()), id: \.offset) { _, subReading in
                                    VStack(alignment: .leading, spacing: 16) {
                                        ForEach(Array((subReading.passages ?? []).enumerated()), id: \.offset) { _, passage in
                                            PassageDetailView(passage: passage, introduction: subReading.introduction, conclusion: subReading.conclusion)
                                                .padding(.bottom, 16)
                                        }
                                    }
                                }
                            }
                        }

                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                }
            }
        }
        .kerning(-0.4)
        .foregroundStyle(.gray900)
        .fontDesign(.rounded)
    }

    private func normalize(_ value: String?) -> String {
        (value ?? "")
            .lowercased()
            .replacingOccurrences(of: "&", with: "and")
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined()
    }
}

struct PassageDetailView: View {
    let passage: Passage
    let introduction: String?
    let conclusion: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            if let bookTranslation = passage.bookTranslation,
               let ref = passage.ref {
                HStack {
                    Text("\(bookTranslation) \(ref)")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }

            if let introduction = introduction {
                Text(introduction)
                    .fontWeight(.medium)
                    .font(.title3)
                    .foregroundStyle(.gray900)
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.primary200)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }

            ForEach(Array((passage.verses ?? []).enumerated()), id: \.offset) { _, verse in
                HStack(alignment: .firstTextBaseline) {
                    if let number = verse.number {
                        Text("\(number)")
                            .font(.callout)
                    }
                    if let text = verse.text {
                        Text(text)
                            .fontWeight(.medium)
                            .font(.title3)
                    }
                }
            }

            if let conclusion = conclusion {
                HStack {
                    Text(conclusion)
                        .fontWeight(.medium)
                        .font(.title3)
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.primary200)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
        }
    }
}

struct LiturgyReadingDetailsView: View {
    let subsection: SubSection
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            
            Rectangle()
                .fill(LinearGradient(colors: [.primary300, .clear], startPoint: .top, endPoint: .bottom))
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .frame(width: 40, height: 5)
                    .foregroundColor(.primary400)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        HStack {
                            Text("Liturgy")
                            Spacer()
                            if let subSectionTitle = subsection.title {
                                Text(subSectionTitle)
                            }
                        }
                        .foregroundStyle(.gray900)
                        .font(.title2)
                        .fontWeight(.semibold)
                        
                        if let introduction = subsection.introduction {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("INTRODUCTION")
                                        .foregroundStyle(.gray900.opacity(0.6))
                                        .fontWeight(.semibold)
                                        .font(.callout)
                                        .kerning(1.3)
                                    Spacer()
                                }

                                Text(introduction)
                                    .fontWeight(.medium)
                                    .font(.title3)
                                    .foregroundStyle(.gray900)
                            }
                            .fontWeight(.medium)
                            .padding(20)
                            .background(.primary200)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        
                        ForEach(Array((subsection.readings ?? []).enumerated()), id: \.offset) { _, subReading in
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(Array((subReading.passages ?? []).enumerated()), id: \.offset) { _, passage in
                                    PassageDetailView(passage: passage, introduction: subReading.introduction, conclusion: subReading.conclusion)
                                        .padding(.bottom, 16)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                }
            }
        }
        .kerning(-0.4)
        .foregroundStyle(.gray900)
        .fontDesign(.rounded)
    }
}


