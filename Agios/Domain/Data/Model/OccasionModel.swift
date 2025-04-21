//
//  OccasionModel.swift
//  Agios
//
//  Created by Victor on 19/04/2024.
//

import Foundation
import SwiftUI

// Response structure to match the JSON data
struct Response: Codable {
    let data: DataClass
}

// MARK: - OccasionModel
struct OccasionModel: Identifiable, Codable {
    var id: String? {
        return "\(status ?? 0) + \(statusText ?? "")"
    }
    //let data: DataClass?
    let status: Int?
    let statusText: String?
}

// MARK: - DataClass
struct DataClass: Identifiable, Codable {
    let created, date: String?
    let copticDate: CopticDate?
    let icons: [IconModel]?
    let stories: [Story]?
    let facts: [Fact]?
    let id: String?
    let liturgicalInformation: String?
    let name, updated: String?
    let readings: [DataReading]?
    let isWellKnown: Bool?
    let upcomingEvents: [DataClass]?
    let notables: [Notable]?
}

// MARK: - CopticDate
struct CopticDate: Identifiable, Codable {
    let created, day, id, month: String?
    let updated: String?
    
    var dayInt: Int? {
        return Int(day ?? "")
    }
}

struct Fact: Codable, Identifiable {
    let created, id, updated, fact: String?
}

// MARK: - Icon
struct IconModel: Hashable, Identifiable, Codable, Equatable {
    let id: String
    let created, updated, caption: String?
    let explanation: String?
    let story: [String]?
    let image: String
    let croppedImage: String?
    let iconagrapher: IconagrapherEnum?
    
    enum IconagrapherEnum: Codable, Equatable, Hashable {
        case iconagrapher(Iconagrapher)
        case string(String)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let iconagrapher = try? container.decode(Iconagrapher.self) {
                self = .iconagrapher(iconagrapher)
            } else if let string = try? container.decode(String.self) {
                self = .string(string)
            } else {
                throw DecodingError.typeMismatch(IconagrapherEnum.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Iconagrapher or String"))
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .iconagrapher(let iconagrapher):
                try container.encode(iconagrapher)
            case .string(let string):
                try container.encode(string)
            }
        }
    }
}

// MARK: - Iconographer
struct Iconagrapher: Codable, Equatable, Hashable {
    let id: String?
    let name: String?
    let url: String?
}

// MARK: - DataReading
struct DataReading: Identifiable, Codable, Equatable {
    let id: Int?
    let title: String?
    let subSections: [SubSection]?

    static func == (lhs: DataReading, rhs: DataReading) -> Bool {
        return lhs.id == rhs.id
    }

    static let pastelColors: [Color] = [
        Color(red: 253 / 255, green: 225 / 255, blue: 225 / 255),  // Pastel Red
        Color(red: 253 / 255, green: 246 / 255, blue: 215 / 255),  // Pastel Yellow
        Color(red: 215 / 255, green: 253 / 255, blue: 221 / 255),  // Pastel Green
        Color(red: 253 / 255, green: 225 / 255, blue: 253 / 255),  // Pastel Pink
        Color(red: 215 / 255, green: 230 / 255, blue: 253 / 255),  // Pastel Blue
        Color(red: 1.0, green: 0.89, blue: 0.71),                  // Pastel Yellow (FFE4B5)
        Color(red: 0.97, green: 0.67, blue: 0.67)                  // Pastel Pink (F8ACAC)
    ]

    // Computed property that assigns a consistent color based on the `id`.
    var color: Color {
        guard let id = id else {
            // Fallback color if id is nil
            return DataReading.pastelColors[0]
        }
        let colorIndex = id % DataReading.pastelColors.count
        return DataReading.pastelColors[colorIndex]
    }
    
    // Computed property that assigns a consistent color based on unique properties or index.
    func color(for index: Int) -> Color {
        // Combine multiple properties to ensure varied colors even if ids are the same
        let hashValue = (id ?? 0) ^ (title?.hashValue ?? 0) ^ index
        let colorIndex = abs(hashValue) % DataReading.pastelColors.count
        return DataReading.pastelColors[colorIndex]
    }
}




// MARK: - SubSection
struct SubSection: Identifiable, Codable, Equatable {
    let id: Int?
    let title: String?
    let introduction: String?
    let readings: [SubSectionReading]?
    
    static func == (lhs: SubSection, rhs: SubSection) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.introduction == rhs.introduction &&
               lhs.readings == rhs.readings
    }
}

// MARK: - SubSectionReading
struct SubSectionReading: Codable, Identifiable, Equatable {
    let id: Int?
    let title: String?
    let introduction: String?
    let conclusion: String?
    let passages: [Passage]?
    let html: String?
}

// MARK: - Passage
struct Passage: Identifiable, Codable, Hashable, Equatable {
    let bookID: Int?
    let bookTranslation: String?
    let chapter: Int?
    let ref: String?
    let verses: [Verse]?
    
    var id: String {
        return "\(bookID ?? -1)-\(chapter ?? -1)-\(ref ?? "unknown")"
    }

    static let pastelColors: [Color] = [
        Color(red: 253 / 255, green: 225 / 255, blue: 225 / 255),  // Pastel Red
        Color(red: 253 / 255, green: 246 / 255, blue: 215 / 255),  // Pastel Yellow
        Color(red: 215 / 255, green: 253 / 255, blue: 221 / 255),  // Pastel Green
        Color(red: 215 / 255, green: 230 / 255, blue: 253 / 255),  // Pastel Blue
        Color(red: 253 / 255, green: 225 / 255, blue: 253 / 255),  // Pastel Pink
        Color(red: 1.0, green: 0.89, blue: 0.71),                  // Pastel Yellow (FFE4B5)
        Color(red: 0.97, green: 0.67, blue: 0.67)                  // Pastel Pink (F8ACAC)
    ]

    // Computed property that assigns a consistent color based on a stable property, such as bookID.
    var color: Color {
        guard let bookID = bookID else {
            // Fallback color if bookID is nil
            return Passage.pastelColors[0]
        }
        // Use bookID to consistently map to a color index
        let colorIndex = bookID % Passage.pastelColors.count
        return Passage.pastelColors[colorIndex]
    }

    enum CodingKeys: String, CodingKey {
        case bookID, bookTranslation, chapter, ref, verses
    }

    // Implementing Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Implementing Equatable protocol
    static func == (lhs: Passage, rhs: Passage) -> Bool {
        return lhs.id == rhs.id &&
        lhs.bookID == rhs.bookID &&
        lhs.bookTranslation == rhs.bookTranslation &&
        lhs.chapter == rhs.chapter &&
        lhs.ref == rhs.ref &&
        lhs.verses == rhs.verses
    }
}


struct PastelColors: ShapeStyle {
    let pastelColors: [Color]
}

struct ColorsArray: ShapeStyle {
    let colors: [Color]
}



// MARK: - Verse
struct Verse: Identifiable, Codable, Equatable {
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
struct Story: Identifiable, Codable {
    let created, id, updated, saint: String?
    let story: String?
    let highlights: [Highlight]?
}

// MARK: - Highlight
struct Highlight: Codable {
    let created, updated: String?
}

// MARK: - Notables
struct Notable: Identifiable, Codable {
    let copticDate: String
    let created: String
    let expand: Expand?
    let id: String
    let story: String
    let title: String
    let updated: String
}

struct Expand: Codable {
    let copticDate: CopticDate
}
