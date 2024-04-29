//
//  String+Extensions.swift
//  Natega
//
//  Created by Nikola Veljanovski on 7.9.23.
//

import Foundation

extension String {
    var psalmAndGospelFormat: String {
        self.replacingOccurrences(of: "Psalm & Gospel", with: "Gospel")
    }
}
