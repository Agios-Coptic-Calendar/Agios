//
//  Quote.swift
//  Agios
//
//  Created by Nikola Veljanovski on 24.9.24.
//

import Foundation

// Struct to represent each quote
struct Quote: Identifiable, Codable {
    let id: Int
    let title: String?
    let body: String
    let author: String
}
