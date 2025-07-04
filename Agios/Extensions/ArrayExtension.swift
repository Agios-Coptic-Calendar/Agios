//
//  File.swift
//  Agios
//
//  Created by Victor Onwuzuruike on 04/07/2025.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
