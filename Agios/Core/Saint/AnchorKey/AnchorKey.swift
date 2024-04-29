//
//  AnchorKey.swift
//  Agios
//
//  Created by Victor on 4/27/24.
//

import Foundation
import SwiftUI

struct AnchorKey: PreferenceKey {
    static let defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
