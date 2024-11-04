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

class OccasionsViewModel: ObservableObject {
    @Published var icons: [IconModel] = []
    @Published var selectedCopticDate: DateModel? = nil
    @Published var filteredIcons: [IconModel] = []
    @Published var stories: [Story] = []
    @Published var readings: [DataReading] = []
    var liturgy: DataReading?
    @Published var selectedItem: Bool = false
    @Published var dataClass: DataClass? = nil
    @Published var subSection: [SubSection] = []
    @Published var subSectionReading: [SubSectionReading] = []
    @Published var passages: [Passage] = []
    @Published var iconagrapher: Iconagrapher? = nil
    @Published var highlight: [Highlight] = []
    @Published var viewState: ViewState = .collapsed
    @Published var newCopticDate: CopticDate? = nil
    @Published var fact: [Fact]? = nil
    @Published var matchedStory: Story? = nil
    @Published var stopDragGesture: Bool = false
    @Published var disallowTapping: Bool = false
    @Published var showUpcomingView: Bool = false
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
        }
    }
    @Published var copticDates: [String] = []
    let mockDates: [DateModel] = [
        DateModel(month: "12", 
                  day: "05", 
                  date: "2024-12-05T12:00:00.000Z",
                  urlLink: "",
                  customDate: Date(), 
                  name: "Feast of the Cross"),
        DateModel(month: "01",
                  day: "07",
                  date: "2025-01-07T00:00:00.000Z",
                  urlLink: "",
                  customDate: Date(), 
                  name: "Feast of Nativity")
    ]
    @Published var selectedMockDate: DateModel? = nil
    @Published var filteredIconsGroups: [[IconModel]] = []
    @Published var selectedGroupIcons: [IconModel] = []
    @Published var showDetailsView: Bool = false
    @Published var draggingDetailsView: Bool = false
    @Published var selectedStory: Story? = nil
    @Published var storiesWithoutIcons: [Story] = []

    var copticEvents: [CopticEvent]?
    var feastName: String?
    var occasionName: String {
        dataClass?.name ?? "Unknown Occasion"
    }
    
    private weak var task: URLSessionDataTask?
    @Published var filteredDate: [DateModel] = []
    
    init() {
        withAnimation {
            self.isLoading = true
        }
        getCopticEvents()
        getPosts()
        getCopticDates()
    }
    
    func date(from copticDateString: String) -> Date? {
        let calendar = Calendar(identifier: .coptic)
        
        // Extract the current Coptic year
        let currentCopticYear = calendar.component(.year, from: Date())
        
        // Split the input string to extract the month name and day
        let components = copticDateString.split(separator: " ")
        guard components.count == 2,
              let day = Int(components[1]) else {
            return nil // Handle incorrect format
        }
        
        let monthName = String(components[0])
        
        // Find the month number corresponding to the Coptic month name
        guard let monthIndex = calendar.monthSymbols.firstIndex(of: monthName) else {
            return nil // Handle invalid month name
        }
        
        // Create the Coptic date components using the current Coptic year
        var dateComponents = DateComponents()
        dateComponents.year = currentCopticYear
        dateComponents.month = monthIndex + 1 // Month index is 0-based
        dateComponents.day = day
        
        // Convert the Coptic date components into a Gregorian Date
        return calendar.date(from: dateComponents)
    }

    private func getCopticDates() {
        let range = Date.dateRange
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
        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
            self.feast = selectedCopticDate?.name ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                withAnimation {
                    self.isLoading = true
                    self.getPosts()
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
        let monthName = calendar.monthSymbols[month - 1]

        return "\(monthName) \(day)"
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: datePicker)
    }
    
    func getPosts() {
        guard let url = URL(string: "https://api.agios.co/occasions/get/date/\(date)") else { return }
        
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                let decodedResponse = try handleOutput(response: response, data: data)
                    await updateUI(with: decodedResponse)
                DispatchQueue.main.async { [weak self] in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        self?.showEventNotLoaded = false
                    }
                }
              
            } catch {
                print("Error fetching data: \(error)")
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
    }
    
    func handleOutput(response: URLResponse, data: Data) throws -> Response {
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
    
    @MainActor
    func updateUI(with response: Response) {
        withAnimation(.spring(response: 0.07, dampingFraction: 0.9, blendDuration: 1)) {
            self.isLoading = false
        }
        self.feast = response.data.name ?? ""
        self.liturgicalInformation = response.data.liturgicalInformation?.replaceCommaWithNewLine
        self.icons = response.data.icons ?? []
        self.stories = response.data.stories ?? []
        self.readings = response.data.readings?.filter { $0.title != "Liturgy"} ?? []
        self.liturgy = response.data.readings?.first { $0.title == "Liturgy" }
        self.dataClass = response.data
        self.newCopticDate = response.data.copticDate ?? nil
        self.fact = response.data.facts ?? []
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
}

