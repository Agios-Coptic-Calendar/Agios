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
    
    static var startingDate: Date {
        if isDebug {
            return Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 1)) ?? Date()
        } else {
            return Calendar.current.date(from: DateComponents(year: 2025, month: 4, day: 21)) ?? Date()
        }
    }
    
    static var endingDate: Date {
        if isDebug {
           return Calendar.current.date(from: DateComponents(year: 2029, month: 1, day: 1)) ?? Date()
        } else {
            return Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 6)) ?? Date()
        }
    }
}
