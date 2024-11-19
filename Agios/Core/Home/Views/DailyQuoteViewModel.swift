//
//  DailyQuoteViewModel.swift
//  Agios
//
//  Created by Nikola Veljanovski on 24.9.24.
//

import Foundation

class DailyQuoteViewModel: ObservableObject {
    @Published var currentQuotes: [Quote] = [] // Array to hold two quotes
    private var quotes: [Quote] = []

    init() {
        loadQuotes()
        selectQuotesForToday()
    }

    private func loadQuotes() {
        if let url = Bundle.main.url(forResource: "dailyQuotes", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let loadedQuotes = try? JSONDecoder().decode([Quote].self, from: data) {
            quotes = loadedQuotes
        } else {
            print("Failed to load quotes from JSON.")
        }
    }

    private func selectQuotesForToday() {
        let today = Calendar.current.startOfDay(for: Date())
        
        // Retrieve saved quotes and date from UserDefaults
        if let savedDate = UserDefaults.standard.object(forKey: "dailyQuotesDate") as? Date,
           Calendar.current.isDate(today, inSameDayAs: savedDate),
           let savedQuotesData = UserDefaults.standard.data(forKey: "dailyQuotes"),
           let savedQuotes = try? JSONDecoder().decode([Quote].self, from: savedQuotesData) {
            currentQuotes = savedQuotes // Use the saved quotes
        } else {
            // Pick two random quotes for the new day
            currentQuotes = Array(quotes.shuffled().prefix(2))
            
            // Save the new quotes and date in UserDefaults
            if let encodedQuotes = try? JSONEncoder().encode(currentQuotes) {
                UserDefaults.standard.set(today, forKey: "dailyQuotesDate")
                UserDefaults.standard.set(encodedQuotes, forKey: "dailyQuotes")
            }
        }
    }
}

