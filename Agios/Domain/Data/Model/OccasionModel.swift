//
//  OccasionModel.swift
//  Agios
//
//  Created by Victor on 19/04/2024.
//

import Foundation

// MARK: - OccasionModel
struct OccasionModel: Codable {
    let data: DataClass?
    let status: Int?
    let statusText: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    let created, date: String?
    let copticDate: CopticDate?
    let icons: [Icon]?
    let stories: [Story]?
    let id, liturgicalInformation, name, updated: String?
    let readings: [DataReading]?
}

// MARK: - CopticDate
struct CopticDate: Codable {
    let created, day, id, month: String?
    let updated: String?
}

// MARK: - Icon
struct Icon: Codable {
    let created, id, updated, caption: String?
    let image: String?
    let croppedImage: String?
    let iconagrapher: Iconagrapher?
}

// MARK: - Iconagrapher
struct Iconagrapher: Codable {
    let created, id, name, updated: String?
}

// MARK: - DataReading
struct DataReading: Codable {
    let id: Int?
    let title: String?
    let subSections: [SubSection]?
}

// MARK: - SubSection
struct SubSection: Codable {
    let id: Int?
    let title: String?
    let introduction: String?
    let readings: [SubSectionReading]?
}

// MARK: - SubSectionReading
struct SubSectionReading: Codable {
    let id: Int?
    let title: String?
    let introduction: String?
    let conclusion: String?
    let passages: [Passage]?
    let html: String?
}

// MARK: - Passage
struct Passage: Codable {
    let bookID: Int?
    let bookTranslation: String?
    let chapter: Int?
    let ref: String?
    let verses: [Verse]?

    enum CodingKeys: String, CodingKey {
        case bookID
        case bookTranslation, chapter, ref, verses
    }
}

// MARK: - Verse
struct Verse: Codable {
    let id, bibleID, bookID, chapter: Int?
    let number: Int?
    let text: String?

    enum CodingKeys: String, CodingKey {
        case id
        case bibleID
        case bookID
        case chapter, number, text
    }
}

// MARK: - Story
struct Story: Codable {
    let created, id, updated, saint: String?
    let story: String?
    let highlights: [Highlight]?
}

// MARK: - Highlight
struct Highlight: Codable {
    let created, updated: String?
}

