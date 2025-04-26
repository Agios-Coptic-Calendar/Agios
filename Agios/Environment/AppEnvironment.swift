//
//  AppEnvironment.swift
//  Agios
//
//  Created by Nikola Veljanovski on 21.4.25.
//

import Foundation

enum AppEnvironment {
    static var isDebug: Bool {
        #if AGIOS_BETA
        return true
        #else
        return false
        #endif
    }
    static var startingDate: Date = Date() // fallback default
    static var endingDate: Date = Date()   // fallback default

    static var dateRange: ClosedRange<Date> {
        startingDate...endingDate
    }

    static func updateDateRange(from range: DateRange) {
        self.startingDate = range.startDate
        self.endingDate = range.endDate
    }
}
