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
        // If the API returns a too-narrow range (e.g., both dates are the same), fall back to a wider date range.
        if Calendar.current.isDate(range.startDate, inSameDayAs: range.endDate) {
            // Expand the range around the single date (e.g. ±3 days)
            let fallbackStart = Calendar.current.date(byAdding: .day, value: -3, to: range.startDate) ?? range.startDate
            let fallbackEnd = Calendar.current.date(byAdding: .day, value: 3, to: range.endDate) ?? range.endDate
            self.startingDate = fallbackStart
            self.endingDate = fallbackEnd
        } else {
            self.startingDate = range.startDate
            self.endingDate = range.endDate
        }
    }
}
