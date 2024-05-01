//import Foundation
//
//// MARK: - Feast
//struct Feast: Codable {
//    let title: String?
//    let bible: Bible
//    let bibles: [Bible]
//    let sections: [Section]
//    let copticDate: String?
//}
//
//// MARK: - Bible
//struct Bible: Codable {
//    let id: Int
//    let name: String?
//    let languageID: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case languageID = "languageId"
//    }
//}
//
//// MARK: - Section
//struct Section: Codable, Identifiable {
//    let id: Int
//    let title: String?
//    let subSections: [SubSection]
//}
//
//// MARK: - SubSection
//struct SubSection: Codable {
//    let id: Int
//    let title: String?
//    let introduction: String?
//    let readings: [Reading]
//}
//
//// MARK: - Reading
//struct Reading: Codable, Identifiable, Hashable {
//    var id: Int
//    let title, introduction, conclusion: String?
//    let passages: [Passage]?
//    let html: String?
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
//
//// MARK: - Passage
//struct Passage: Codable, Identifiable, Equatable {
//    let id: UUID = UUID()
//    let bookID: Int?
//    let bookTranslation: String?
//    let chapter: Int?
//    let ref: String
//    let verses: [Verse]
//    
//    static func == (lhs: Passage, rhs: Passage) -> Bool {
//        lhs.id == rhs.id &&
//        lhs.bookID == rhs.bookID &&
//        lhs.bookTranslation == rhs.bookTranslation &&
//        lhs.chapter == rhs.chapter &&
//        lhs.ref == rhs.ref
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case bookID = "bookId"
//        case bookTranslation, chapter, ref, verses
//    }
//}
//
//// MARK: - Verse
//struct Verse: Codable, Identifiable {
//    let id, bibleID, bookID, chapter: Int
//    let number: Int
//    let text: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case bibleID = "bibleId"
//        case bookID = "bookId"
//        case chapter, number, text
//    }
//}
