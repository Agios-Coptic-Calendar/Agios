//
//  ReadingView.swift
//  Agios
//
//  Created by Nikola Veljanovski on 4.7.24.
//

import SwiftUI

struct ReadingView: View {
    @Binding var reading: DataReading
    var onCardTap: ((_ subsectionTitle: String, _ subSectionIndex: Int, _ subReadingIndex: Int?) -> Void)?

    private var cards: [ReadingCard] {
        let subSections = reading.subSections ?? []
        var result: [ReadingCard] = []

        for (subSectionIndex, subsection) in subSections.enumerated() {
            let subReadings = subsection.readings ?? []

            if shouldCombineSubReadings(for: subsection.title) {
                let combinedPassages = subReadings.flatMap { $0.passages ?? [] }
                result.append(
                    ReadingCard(
                        id: "s\(subSectionIndex)-combined",
                        subsectionTitle: subsection.title ?? "",
                        subSectionIndex: subSectionIndex,
                        subReadingIndex: nil,
                        subsection: subsection,
                        passages: combinedPassages
                    )
                )
            } else if subReadings.isEmpty {
                result.append(
                    ReadingCard(
                        id: "s\(subSectionIndex)-empty",
                        subsectionTitle: subsection.title ?? "",
                        subSectionIndex: subSectionIndex,
                        subReadingIndex: nil,
                        subsection: subsection,
                        passages: []
                    )
                )
            } else {
                for (subReadingIndex, subReading) in subReadings.enumerated() {
                    result.append(
                        ReadingCard(
                            id: "s\(subSectionIndex)-r\(subReadingIndex)",
                            subsectionTitle: subsection.title ?? "",
                            subSectionIndex: subSectionIndex,
                            subReadingIndex: subReadingIndex,
                            subsection: subsection,
                            passages: subReading.passages ?? []
                        )
                    )
                }
            }
        }

        return result
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ForEach(cards) { card in
                SubsectionView(
                    mainReadingTitle: reading.title ?? "No title",
                    subsection: card.subsection,
                    passagesOverride: card.passages
                )
                .padding(16)
                .background(reading.color.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .onTapGesture {
                    onCardTap?(card.subsectionTitle, card.subSectionIndex, card.subReadingIndex)
                }
            }
        }
    }

    private func shouldCombineSubReadings(for title: String?) -> Bool {
        normalize(title).contains("psalmandgospel")
    }

    private func normalize(_ value: String?) -> String {
        (value ?? "")
            .lowercased()
            .replacingOccurrences(of: "&", with: "and")
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined()
    }
}

private struct ReadingCard: Identifiable {
    let id: String
    let subsectionTitle: String
    let subSectionIndex: Int
    let subReadingIndex: Int?
    let subsection: SubSection
    let passages: [Passage]
}

#Preview {
    ReadingView(reading: .constant(DataReading(id: 1, title: "Vespres", subSections: [SubSection(id: 2,
                                                                                       title: "Psalm & Gospel", introduction: nil, readings: [SubSectionReading(id: 3, title: nil, introduction: nil, conclusion: nil, passages: [Passage(bookID: 0, bookTranslation: "Psalms", chapter: nil, ref: "118:8-9", verses: [])], html: nil)])])))
}


struct SubsectionView: View {
    let mainReadingTitle: String
    let subsection: SubSection
    let passagesOverride: [Passage]?

    init(
        mainReadingTitle: String,
        subsection: SubSection,
        passagesOverride: [Passage]? = nil
    ) {
        self.mainReadingTitle = mainReadingTitle
        self.subsection = subsection
        self.passagesOverride = passagesOverride
    }

    var body: some View {
        let passages = passagesOverride ?? ((subsection.readings ?? []).flatMap { $0.passages ?? [] })

        VStack(alignment: .leading, spacing: 4) {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(Array(passages.enumerated()), id: \.offset) { _, passage in
                    PassageView(passage: passage)
                }
            }
            .frame(height: 60, alignment: .top)
            .clipped()

            Spacer()

            HStack(spacing: 4) {
                Text(mainReadingTitle)
                Circle()
                    .frame(width: 4, height: 4, alignment: .center)
                Text(subsection.title ?? "")
            }
            .font(.body)
            .fontWeight(.medium)
            .foregroundStyle(.gray900)
        }
        .frame(height: 90)
    }
}


struct PassageView: View {
    let passage: Passage
    
    var body: some View {
        Text("\(passage.bookTranslation ?? "") \(passage.ref ?? "")")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(.gray900)
    }
}

