//
//  DailyQuoteViewModel.swift
//  Agios
//
//  Created by Nikola Veljanovski on 24.9.24.
//

import Foundation
class DailyQuoteViewModel: ObservableObject {
    @Published var currentQuote: Quote?
    private var quotes: [Quote] = []
    
    init() {
        loadQuotes()
        Task {
           await selectQuoteOfTheDay()
        }
    }

    func selectRandomQuote() {
        currentQuote = quotes.randomElement()
    }
    
    // Load the quotes from the JSON file (you'll need to adjust the JSON path accordingly)
    private func loadQuotes() {
        if let url = Bundle.main.url(forResource: "dailyQuotes", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedQuotes = try? JSONDecoder().decode([Quote].self, from: data) {
            self.quotes = decodedQuotes
        }
    }
    
    // Select a new quote if a day has passed
    @MainActor
    private func selectQuoteOfTheDay() async {
        guard !quotes.isEmpty else { return }
        let lastUpdate = UserDefaults.standard.object(forKey: "lastUpdate") as? Date ?? Date.distantPast
        if !Calendar.current.isDateInToday(lastUpdate) {
            UserDefaults.standard.set(Date(), forKey: "lastUpdate")
            selectRandomQuote()
            if let currentQuote = currentQuote {
                UserDefaults.standard.set(currentQuote.id, forKey: "quoteOfTheDayID")
            }
        } else {
            if let quoteID = UserDefaults.standard.value(forKey: "quoteOfTheDayID") as? Int {
                currentQuote = quotes.first { $0.id == quoteID }
            }
        }
    }
}
