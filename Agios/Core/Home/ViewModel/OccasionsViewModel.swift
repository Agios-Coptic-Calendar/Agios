//
//  OccasionsViewModel.swift
//  Agios
//
//  Created by Victor on 19/04/2024.
//

import Foundation
import Combine
import SwiftUI

struct DateModel: Identifiable {
    let id: String = UUID().uuidString
    let month: String
    let day: String
    let date: String
    var urlLink: String
    var customDate: Date
    var name: String
}

enum ViewState {
    case collapsed
    case expanded
    case imageView
}

struct CopticMonth: Identifiable {
    var id = UUID()
    let name: String
    var dates: [String]
}


class OccasionsViewModel: ObservableObject {
    let dailyQuotesViewModel = DailyQuoteViewModel()
    @Published var icons: [IconModel] = []
    @Published var filteredIcons: [IconModel] = []
    @Published var stories: [Story] = []
    @Published var readings: [DataReading] = []
    var liturgy: DataReading?
    @Published var selectedItem: Bool = false
    @Published var notables: [Notable] = []
    @Published var dataClass: DataClass? = nil
    @Published var subSection: [SubSection] = []
    @Published var subSectionReading: [SubSectionReading] = []
    @Published var passages: [Passage] = []
    @Published var iconagrapher: Iconagrapher? = nil
    @Published var highlight: [Highlight] = []
    @Published var viewState: ViewState = .collapsed
    @Published var newCopticDate: CopticDate? = nil
    @Published var setCopticDate: CopticDate? = nil
    @Published var fact: [Fact]? = nil
    @Published var matchedStory: Story? = nil
    @Published var stopDragGesture: Bool = false
    @Published var disallowTapping: Bool = false
    @Published var selectedNotable: Notable?
    @Published var showUpcomingView: Bool? = false
    @Published var isShowingFeastName = true
    @Published var isLoading: Bool = false
    @Published var copticDateTapped: Bool = false
    @Published var defaultDateTapped: Bool = false
    @Published var openSheet: Bool = false
    @Published var selectedDate: Date = Date()
    @Published var showImageViewer: Bool = false
    @Published var selectedSaint: IconModel? = nil
    @Published var imageViewerOffset: CGSize = .zero
    @Published var backgroundOpacity: Double = 1
    @Published var imageScaling: Double = 1
    @Published var searchDate: String = ""
    @Published var showLaunchView: Bool = false
    @Published var selectedReading: DataReading?
    @Published var selectedLiturgy: SubSection?
    @Published var showImageView: Bool = false
    @Published var showStory: Bool? = false
    @Published var showReading: Bool? = false
    @Published var liturgicalInfoTapped: Bool = false
    @Published var liturgicalInformation: String?
    @Published var searchText: Bool = false
    @Published var isTextFieldFocused: Bool = false
    @Published var saintTapped: Bool = false
    @State var dataNotLoaded: Bool = false
    @Published var showEventNotLoaded = false
    @Published var showCrest: Bool = false
    @Published var feast: String = ""
    @Published var datePicker: Date = Date() {
        didSet {
            filterDate()
            saveSelectedDateToSharedStorage(datePicker)
        }
    }
    @Published var copticDates: [String] = []
    @Published var allCopticMonths: [CopticMonth] = []
    @Published var selectedCopticMonth: CopticMonth? = nil
    @Published var passedDate: [String] = []
    @Published var setColor: Bool = false
    private var yearAheadFeastsFetched = false
    private var datePickerLimitsFetched = false
    let mockDates: [DateModel] = [
        DateModel(month: "01",
                  day: "07",
                  date: "2025-01-07T12:00:00.000Z",
                  urlLink: "",
                  customDate: Date(),
                  name: "Feast of the Holy Nativity"),
        DateModel(month: "01",
                  day: "07",
                  date: "2025-01-07T00:00:00.000Z",
                  urlLink: "",
                  customDate: Date(),
                  name: "Jonah's Fast")
    ]

    @Published var selectedMockDate: DateModel? = nil
    @Published var filteredIconsGroups: [[IconModel]] = []
    @Published var selectedGroupIcons: [IconModel] = []
    @Published var showDetailsView: Bool = false
    @Published var draggingDetailsView: Bool = false
    @Published var selectedStory: Story? = nil
    @Published var storiesWithoutIcons: [Story] = []
    @Published var yearAheadFeasts: [YearAheadFeast] = YearAheadFeast.items
    @Published var dateRange: DateRange = DateRange(startDate: Date(),
                                                    endDate: Date())
    var copticEvents: [CopticEvent]?
    var feastName: String?
    var occasionName: String {
        dataClass?.name ?? "Unknown Occasion"
    }
    
    private weak var task: URLSessionDataTask?
    @Published var filteredDate: [DateModel] = []
    private let copticMonths = [
        "Tout": 30, "Baba": 30, "Hator": 30, "Kiahk": 30, "Toba": 30,
        "Amshir": 30, "Baramhat": 30, "Baramouda": 30, "Bashans": 30,
        "Baounah": 30, "Epep": 30, "Mesra": 30, "Nasie": 5 // Leap years: 6
    ]

    private var debounceTimer: Timer?
    private var retryCount = 0
    private let maxRetries = 3
    
    @Published var selectedCopticYear: String = {
        let copticCalendar = Calendar(identifier: .coptic)
        let currentYear = copticCalendar.component(.year, from: Date())
        return String(currentYear)
    }()
    
    @Published var availableCopticYears: [String] = []

    init() {
        loadSavedDate()
        getCopticEvents()
        getCopticDates()
        getCopticDatesCategorized(forYear: selectedCopticYear)
        populateAvailableCopticYears()
        
        // Delay the initial API call slightly to avoid conflicts
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation {
                self.isLoading = true
            }
            self.getPosts()
        }
    }
        
    func fetchFeasts() {
        guard let url = URL(string: "https://api.agios.co/yearAheadFeasts"),
        !yearAheadFeastsFetched else {
            return
        }
        Task { @MainActor in
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                yearAheadFeasts = try JSONDecoder().decode([YearAheadFeast].self, from: data)
                yearAheadFeastsFetched = true
                fetchDatePickerLimits()
            } catch {
                print(error)
            }
        }
    }
    func fetchDatePickerLimits() {
        guard let url = URL(string: "https://api.agios.co/datePickerLimits"),
        !datePickerLimitsFetched else {
            return
        }
        Task { @MainActor in
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZ"
                decoder.dateDecodingStrategy = .formatted(formatter)
                dateRange = try decoder.decode(DateRange.self, from: data)
                AppEnvironment.updateDateRange(from: dateRange)
                self.populateAvailableCopticYears()
                datePickerLimitsFetched = true
                onSelectYear(selectedCopticYear)
                
                // Add a small delay to ensure the date range is properly set
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                    getCopticDatesCategorized()
                }
            } catch {
                print("Error fetching date picker limits: \(error)")
            }
        }
    }

    private func loadSavedDate() {
        let defaults = UserDefaults(suiteName: "group.com.agios")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let today = formatter.string(from: Date())
        if let savedDate = defaults?.string(forKey: "selectedDate"), savedDate == today {
            // If the saved date is today, load it into selectedDate
            self.selectedDate = formatter.date(from: savedDate) ?? Date()
        } else {
            // Otherwise, set to today and save it
            self.selectedDate = Date()
            saveSelectedDateToSharedStorage(self.selectedDate)
        }
    }

    func saveSelectedDateToSharedStorage(_ date: Date) {
        let defaults = UserDefaults(suiteName: "group.com.agios")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatter.string(from: date)
        defaults?.set(formattedDate, forKey: "selectedDate")
        
        // Print the saved date to confirm
        print("Saved date to app group: \(formattedDate)")
    }

    
    func date(from copticDateString: String) -> Date? {
        let calendar = Calendar(identifier: .coptic)

        // 1. Year
        let yearInt = Int(selectedCopticYear) ??
                      calendar.component(.year, from: Date())

        // 2. Split "Baounah 3"
        let parts = copticDateString.split(separator: " ")
        guard parts.count == 2, let day = Int(parts[1]) else { return nil }
        let monthName = String(parts[0])

        // 3. Month number
        guard let monthIndex = calendar.monthSymbols.firstIndex(of: monthName) else { return nil }

        // 4. Compose components
        var comps = DateComponents()
        comps.year  = yearInt
        comps.month = monthIndex + 1
        comps.day   = day

        // 5. Convert to Gregorian ↴
        return calendar.date(from: comps)
    }

    private func getCopticDates() {
        let range = AppEnvironment.dateRange
        let calendar = Calendar.current
        var currentDate = range.lowerBound
        while currentDate <= range.upperBound {
            let copticDateString = copticDate(for: currentDate)
            copticDates.append(copticDateString)
            // Move to the next day
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            } else {
                break // In case date calculation fails
            }
            
        }
    }
    
    func copticYear(for date: Date) -> String {
        let calendar = Calendar(identifier: .coptic)
        let year = calendar.component(.year, from: date)
        return "\(year)"
    }

    func onSelectYear(_ year: String) {
        // keep the early-out if the user taps the same year
        guard year != selectedCopticYear else { return }
        selectedCopticYear   = year
        // ✱ Reset year-specific highlights ✱
        selectedCopticMonth  = nil          // clears the dot
        newCopticDate        = nil          // clears the stroke
        setColor             = false        // makes sure nothing is tinted

        getCopticDatesCategorized(forYear: year)

    }


    private func getCopticDatesCategorized(forYear selectedYear: String? = nil) {
        let range = AppEnvironment.dateRange
        let calendar = Calendar.current
        var currentDate = range.lowerBound
        var categorizedDates: [String: [String]] = [:]
        let copticMonthOrder = self.copticMonthOrder
        
        print("Date range: \(range.lowerBound) to \(range.upperBound)")
        
        while currentDate <= range.upperBound {
            let copticDateString = copticDate(for: currentDate)
            let copticYear = copticYear(for: currentDate)

            if selectedYear == nil || selectedYear == copticYear {
                let components = copticDateString.split(separator: " ")
                if components.count == 2 {
                    let month = String(components[0])
                    if var arr = categorizedDates[month] {
                        if !arr.contains(copticDateString) {
                            arr.append(copticDateString)
                            categorizedDates[month] = arr
                        }
                    } else {
                        categorizedDates[month] = [copticDateString]
                    }
                }
            }
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        
        self.allCopticMonths = copticMonthOrder.compactMap { monthName in
            if monthName == "Baounah" {
                if let dates = categorizedDates["Baounah"] {
                    return CopticMonth(name: "Baounah", dates: dates)
                } else if let dates = categorizedDates["Paona"] {
                    let updatedArray = dates.map { $0.replacingOccurrences(of: "Paona", with: "Baounah") }
                    return CopticMonth(name: "Baounah", dates: updatedArray)
                }
            }

            if let dates = categorizedDates[monthName] {
                return CopticMonth(name: monthName, dates: dates)
            }
            return nil
        }
    }
    
    func populateAvailableCopticYears() {
        // 1. Which span are we allowed to show?
        let range = AppEnvironment.dateRange        // ← already filled by the API

        // 2. Walk through that span and collect Coptic years
        let copticCalendar   = Calendar(identifier: .coptic)
        var currentDate      = range.lowerBound
        var uniqueYears      = Set<Int>()

        while currentDate <= range.upperBound {
            uniqueYears.insert( copticCalendar.component(.year, from: currentDate) )
            // advance one day
            guard let next = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = next
        }

        // 3. Publish to the UI (latest year first so “this year” is at the top)
        availableCopticYears = uniqueYears.sorted(by: >).map { String($0) }

        // 4. Keep the selection valid
        if !availableCopticYears.contains(selectedCopticYear) {
            selectedCopticYear = availableCopticYears.first ?? selectedCopticYear
        }
    }

    private func loadJSONFromFile<T: Decodable>(fileName: String) -> T? {
        // Get the path for the JSON file
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            print("Invalid file path.")
            return nil
        }

        do {
            // Read the data from the file
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            
            // Decode the data to an array of CopticEvent
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    private func getCopticEvents() {
       copticEvents = loadJSONFromFile(fileName: "copticEvents")
    }

    func filterDate() {
        // Cancel previous timer
        debounceTimer?.invalidate()
        
        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
            // Debounce the API call by 500ms
            debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                DispatchQueue.main.async {
                    withAnimation {
                        self?.isLoading = true
                        self?.getPosts()
                        self?.selectedCopticMonth = nil
                    }
                    
                    // Get Coptic year from selectedDate
                    let copticCalendar = Calendar(identifier: .coptic)
                    let copticYear = copticCalendar.component(.year, from: self?.selectedDate ?? Date())
                    let copticYearString = String(copticYear)

                    // Set selectedCopticYear only if it exists in availableCopticYears
                    if ((self?.availableCopticYears.contains(copticYearString)) != nil) {
                        self?.selectedCopticYear = copticYearString
                    } else {
                        self?.selectedCopticYear = self?.availableCopticYears.first ?? copticYearString
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.88)) {
                    self.defaultDateTapped = false
                }
            }
        }
    }
    
    func copticDate(for date: Date) -> String {
        let calendar = Calendar(identifier: .coptic)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        // Use your app’s internal month naming
        let copticMonthNames = copticMonthOrder
        
        // Make sure the index is valid
        let correctedMonthName = copticMonthNames[safe: month - 1] ?? "Unknown"

        return "\(correctedMonthName) \(day)"
    }
    
    let copticMonthOrder =  [
        "Tout", "Baba", "Hator", "Kiahk", "Toba",
        "Amshir", "Baramhat", "Baramouda", "Bashans",
        "Baounah", "Epep", "Mesra", "Nasie" // Leap years: 6
    ]

    func daysUntilFeast(feastDate: Expand?) -> Int? {
        guard
            let feastDate,
            let currentDay = newCopticDate?.dayInt,
            let feastDay = feastDate.copticDate?.dayInt,
            let currentMonthDays = copticMonths[newCopticDate?.month ?? ""]
        else {
            return nil // Invalid month names
        }

        if newCopticDate?.month == feastDate.copticDate?.month {
            return feastDay - currentDay
        }

        let currentMonthIndex = copticMonthOrder.firstIndex(of: newCopticDate?.month ?? "")
        let targetMonthIndex = copticMonthOrder.firstIndex(of: feastDate.copticDate?.month ?? "")

        guard let currentIndex = currentMonthIndex, let targetIndex = targetMonthIndex else {
            return nil // Invalid month names
        }

        var days = 0
        // Days remaining in the current month
        days += currentMonthDays - currentDay

        // Add days in the months between
        var nextMonthIndex = (currentIndex + 1) % copticMonthOrder.count
        while nextMonthIndex != targetIndex {
            let nextMonth = copticMonthOrder[nextMonthIndex]
            days += copticMonths[nextMonth] ?? 0
            nextMonthIndex = (nextMonthIndex + 1) % copticMonthOrder.count
        }

        // Add days of the target month
        days += feastDay
        return days
    }
    
    func regularDate(for copticDate: CopticDate) -> String? {
        // Ensure the Coptic date has valid day and month
        guard let day = copticDate.dayInt,
              let monthName = copticDate.month,
              let copticMonthIndex = copticMonthOrder.firstIndex(of: monthName) else {
            return nil
        }
        
        // Get the current year in the Gregorian calendar
        _ = Calendar(identifier: .gregorian).component(.year, from: Date())
        
        // Create a Coptic calendar instance
        let copticCalendar = Calendar(identifier: .coptic)
        let copticYear = Int(selectedCopticYear) ??
                         copticCalendar.component(.year, from: Date())
        
        // Create a DateComponents instance for the Coptic date
        var copticDateComponents = DateComponents(calendar: copticCalendar)
        copticDateComponents.year = copticYear
        copticDateComponents.month = copticMonthIndex + 1 // Months are 1-indexed
        copticDateComponents.day = day
        
        // Convert the Coptic date to Gregorian
        guard let gregorianDate = copticCalendar.date(from: copticDateComponents) else {
            return nil
        }
        
        // Format the Gregorian date
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy" // Example: "Wed, Nov 23, 2024"
        return formatter.string(from: gregorianDate)
    }

    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: datePicker)
    }

    func getPosts(isRetry: Bool = false) {
        if !isRetry {
            retryCount = 0
        }        // Cancel any existing task
        task?.cancel()
        
        guard let url = URL(string: "https://api.agios.co/occasions/get/date/\(date)") else { return }
        
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error as NSError?, error.code == NSURLErrorCancelled {
                    return
                }
                
                if let error = error {
                    print("Error fetching data: \(error)")
                    self.handleError()
                    return
                }
                
                guard let data = data, let response = response else {
                    print("No data or response received")
                    self.handleError()
                    return
                }
                
                do {
                    let decodedResponse = try self.handleOutput(response: response, data: data)
                    self.updateUI(with: decodedResponse)
                    self.fetchFeasts()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        self.showEventNotLoaded = false
                    }
                } catch {
                    print("Error decoding data: \(error)")
                    self.handleError()
                }
            }
        }
        
        task?.resume()
    }

    private func handleError() {
        if retryCount < maxRetries {
            retryCount += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(retryCount)) { [weak self] in
                self?.getPosts(isRetry: true)
            }
        } else {
            // Show error to user
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    self?.showEventNotLoaded = true
                }
                if self?.showEventNotLoaded ?? false && (self?.isLoading ?? false) {
                    HapticsManager.instance.notification(type: .error)
                }
            }
        }
    }
    
    func handleOutput(response: URLResponse, data: Data) throws -> Response {
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
    
    func updateUI(with response: Response) {
        self.feast = response.data.name ?? ""
        self.liturgicalInformation = response.data.liturgicalInformation?.replaceCommaWithNewLine
        self.icons = response.data.icons ?? []
        self.stories = response.data.stories ?? []
        self.readings = response.data.readings?.filter { $0.title != "Liturgy"} ?? []
        self.liturgy = response.data.readings?.first { $0.title == "Liturgy" }
        self.dataClass = response.data
        self.newCopticDate = response.data.copticDate ?? nil
        self.setCopticDate = response.data.copticDate ?? nil
        self.fact = response.data.facts ?? []
        self.notables = response.data.notables?.filter {
            !($0.expand?.copticDate?.dayInt == newCopticDate?.dayInt && $0.expand?.copticDate?.month == newCopticDate?.month)
        } ?? []

        self.retrievePassages()
        
        for icon in response.data.icons ?? [] {
            if case let .iconagrapher(iconagrapher) = icon.iconagrapher {
                self.iconagrapher = iconagrapher
                print(" \(icon.caption ?? "") has an Iconagrapher: \(iconagrapher)")
                } else {
                    print("No Iconagrapher assigned for icon with ID: \(icon.caption ?? "")")
                }
            
            for story in response.data.stories ?? [] {
                if icon.story?.first == story.id ?? "" {
                    self.matchedStory = story
                }
            }
        }
        

        self.subSection = readings.flatMap { $0.subSections ?? [] }
        for story in self.stories {
            self.highlight = story.highlights ?? []
        }
        
        filterIconsWithSimilarStories()
        withAnimation(.spring(response: 0.07, dampingFraction: 0.9, blendDuration: 1)) {
            self.isLoading = false
        }
    }
    
    // Function to filter icons that share the same or similar story strings, and include unique icons
    func filterIconsWithSimilarStories() {
        var storyGroups: [String: [IconModel]] = [:]
        var emptyStoryIcons: [IconModel] = [] // For icons with empty or nil stories
        var seenIconIDs: Set<String> = []
        var groupedIcons: [[IconModel]] = []

        // Group icons by their story strings
        for icon in icons {
            if let storyArray = icon.story, !storyArray.isEmpty {
                for storyElement in storyArray {
                    storyGroups[storyElement, default: []].append(icon)
                }
            } else {
                // Add icons with empty or nil stories to the emptyStoryIcons group
                emptyStoryIcons.append(icon)
            }
        }

        // Iterate over the original list of icons to maintain API order
        for icon in icons {
            if seenIconIDs.contains(icon.id) {
                continue // Skip icons that have already been added
            }
            
            if let storyArray = icon.story, !storyArray.isEmpty {
                var iconGroup: [IconModel] = []
                var isSharedStory = false

                // Check if the icon is part of a group sharing story elements
                for storyElement in storyArray {
                    if let group = storyGroups[storyElement], group.count > 1 {
                        isSharedStory = true
                        iconGroup = group.filter { seenIconIDs.insert($0.id).inserted }
                        break // Add the first shared story group found
                    }
                }
                
                if isSharedStory {
                    groupedIcons.append(iconGroup)
                } else {
                    // If the icon has unique story elements, add it as a single-item group
                    groupedIcons.append([icon])
                    seenIconIDs.insert(icon.id)
                }
            } else {
                // Handle icons with empty or nil stories as a group
                if !emptyStoryIcons.isEmpty && emptyStoryIcons.contains(icon) {
                    groupedIcons.append(emptyStoryIcons)
                    seenIconIDs.formUnion(emptyStoryIcons.map { $0.id })
                }
            }
        }

        storiesWithoutIcons = getNonMatchingStories(forIcons: icons)
        print("Non-matching stories: \(storiesWithoutIcons.count)")

        // Update filteredIconsGroups and clear grouped icons from the main array
        filteredIconsGroups = groupedIcons
        icons.removeAll { seenIconIDs.contains($0.id) }
    }
    
    func removeIconsWithCaption(icons: [IconModel], phrase: String) -> [IconModel] {
        return icons.filter { !($0.caption?.localizedCaseInsensitiveContains(phrase) ?? false) }
    }
    
    func retrievePassages() {
        passages = readings.compactMap { $0.subSections }.flatMap{ $0 }.compactMap { $0.readings }.flatMap { $0 }.compactMap { $0.passages }.flatMap { $0 }
    }
    
    func formattedDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date)
        formatter.dateStyle = .long
        return "\(day) \(month)"
    }
    
    var copticDate: String {
        Date.copticDate()
    }
    
    var fastView: String {
        isShowingFeastName ? feastName ?? "" : liturgicalInformation ?? ""
    }
    
    func filterIconsByCaption(captionKeyword: String) -> [IconModel] {
        return icons.filter { $0.caption?.contains(captionKeyword) == true }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func updateIconsWithFilteredIcons() {
        for filteredIcon in filteredIcons {
            if let index = icons.firstIndex(where: { $0.caption == filteredIcon.caption }) {
                icons[index] = filteredIcon
            } else {
                icons.append(filteredIcon)
            }
        }
    }
    
    func filterAndUpdateIconsByCaption(captionKeyword: String) {
        filteredIcons = filterIconsByCaption(captionKeyword: captionKeyword)
        updateIconsWithFilteredIcons()
    }
    
    func filterIconsByCaption(icons: [IconModel], captionKeyword: String) -> [IconModel] {
        return icons.filter { $0.caption?.contains(captionKeyword) == true }
    }
    
    func getStory(forIcon icon: IconModel) -> Story? {
        guard let iconStories = icon.story,
              let story = stories.first(where: { iconStories.contains($0.id ?? "" )})
        else { return nil }
        return story
    }
    
    func getNonMatchingStories(forIcons icons: [IconModel]) -> [Story] {
        // Collect all story IDs associated with the provided icons
        let associatedStoryIDs = Set(icons.compactMap { $0.story }.flatMap { $0 })
        
        // Filter out stories where the ID is not in the associated story IDs
        return stories.filter { story in
            guard let storyID = story.id else { return true } // Include stories with nil IDs
            return !associatedStoryIDs.contains(storyID) // stories where the ID is not in associatedStoryIDs
        }
    }


    
    func formattedDate(from dateString: String) -> String? {
        let inputFormatter = ISO8601DateFormatter()
        guard let date = inputFormatter.date(from: dateString) else { return nil }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"
        return outputFormatter.string(from: date)
    }
    
    func formatDateStringToRelativeDay(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "E, d MMM"
            return dateFormatter.string(from: date)
        }
    }
    
    func formatDateStringToFullDate(dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = inputFormatter.date(from: dateString) else {
            return "–"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"
        
        return outputFormatter.string(from: date)
    }
    
    func formatDateStringToShortDate(dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = inputFormatter.date(from: dateString) else {
            return "–"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMM ''yy"
        
        return outputFormatter.string(from: date)
    }
    
    func formatDateStringToTime(dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let date = inputFormatter.date(from: dateString) else {
            return "–"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mma"
        outputFormatter.amSymbol = "am"
        outputFormatter.pmSymbol = "pm"
        
        return outputFormatter.string(from: date).lowercased()
    }
    
    func inDaysLabel(for day: Int) -> String {
        if day == 1 {
            return "In 1 day"
        } else {
            return "In \(day) days"
        }
    }
}
