//
//  HomeVIewModel.swift
//  Agios
//
//  Created by Victor on 18/04/2024.
//

import SwiftUI
import Combine

//final class HomeViewModel: ObservableObject {
//    let readingsCase: LoadReadingsUseCaseType
//    let loadJsonCase: LoadJsonUseCaseProtocol
//    var colors: [Color] {
//        [
//            Color(uiColor: backgroundColor.withAlphaComponent(0.3)),
//            Color(uiColor: backgroundColor)
//        ]
//    }
//    var fastView: String {
//        isShowingFeastName ? feastName ?? "" : liturgicalInformation ?? ""
//    }
//    var feastName: String?
//    var liturgicalInformation: String?
//    var saintIconModels: [SaintIconModel] = []
//    
//    // Published properties
//    @Published var isShowingFeastName = true
//    @Published var presentableSections: [PresentableSection] = []
//    @Published var sections: [Section] = []
//    @Published var synaxars: [Reading] = []
//    @Published var readings: Feast?
//    @Published var iconModels: [IconModel] = []
//    @Published var upcomingFeasts: [UpcomingFeast] = []
//    @Published var state: State = .loading
//    @Published var backgroundColor: UIColor = .clear
//    // Private properties
//    private var cancellables = Set<AnyCancellable>()
//    
//    // MARK: - Init
//    init(readingsCase: LoadReadingsUseCaseType,
//         loadJsonCase: LoadJsonUseCaseProtocol) {
//        self.readingsCase = readingsCase
//        self.loadJsonCase = loadJsonCase
//    }
//    
//    func loadReadings() {
//        readingsCase
//            .execute()
//            .receive(on: RunLoop.main)
//            .sink { _ in
//                // Intentionally empty
//            }
//        receiveValue: { [weak self] readings in
//            // Clearing the lists
//            self?.presentableSections.removeAll()
//            self?.synaxars.removeAll()
//            
//            self?.readings = readings
//            self?.setSynaxars()
//            self?.setPresentableSections()
//            self?.update(state: .ready)
//        }
//        .store(in: &cancellables)
//    }
//
//    
//    func loadJson() {
//        let icons: AnyPublisher<[IconModel], Error> = loadJsonCase.execute(fileName: "icons2023")
//        icons.sink { completion in
//            print(completion)
//        } receiveValue: { [weak self] model in
//            // Clearing the list
//            self?.saintIconModels.removeAll()
//            let dataForCurrentYear = model.filter { $0.year == Date.currentYear }
//            if let dataForToday = dataForCurrentYear.filter({ $0.copticDate == self?.copticDate }).first {
//                self?.checkIfEmpty(data: dataForToday)
//                dataForToday.saintIcon.forEach({
//                    self?.saintIconModels.append(SaintIconModel(name: $0))
//                })
//                self?.feastName = dataForToday.feastName
//                self?.liturgicalInformation = dataForToday.liturgicalInformation
//                self?.upcomingFeasts = dataForToday.upcomingEvents
//            }
//        }
//        .store(in: &cancellables)
//    }
//
//    func showLiturgicalInfo() {
//        guard let liturgicalInformation = liturgicalInformation else { return }
//        let text = liturgicalInformation.replacingOccurrences(of: ", ", with: "\n\n")
//        self.liturgicalInformation = text
//        withAnimation() {
//            isShowingFeastName.toggle()
//        }
//    }
//    
//    private func checkIfEmpty(data: IconModel) {
//        if data.saintIcon.isEmpty {
//            saintIconModels.append(SaintIconModel(name: "placeholder"))
//        }
//    }
//    
//    func onAppear() {
//        loadReadings()
//        loadJson()
//    }
//
//    func formattedDate() -> String {
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd"
//        let day = formatter.string(from: date)
//        formatter.dateFormat = "MMMM"
//        let month = formatter.string(from: date)
//        formatter.dateStyle = .long
//        return "\(day) " + "\(month)"
//    }
//    
//    var copticDate: String {
//       Date.copticDate()
//    }
//    
//    private func update(state: State) {
//        self.state = state
//    }
//        
//    enum State {
//        case loading
//        case ready
//    }
//    
//    private func setSynaxars() {
//        let sections = readings.map { $0.sections }
//        let liturgy = sections?.first(where: { $0.title == "Liturgy" })
//        let synaxars = liturgy?.subSections.first(where: { $0.title == "Synaxarium" })
//        self.synaxars = synaxars?.readings ?? []
//    }
//
//    private func setPresentableSections() {
//        let sections = readings.map { $0.sections }
//        self.sections = sections ?? []
//        var psalmAndGospels = [PsalmAndGospel]()
//        self.sections.forEach({ section in
//            let subSections = section.subSections.filter { $0.title != "Synaxarium" }
//            subSections.forEach { subSection in
//                if subSection.title == "Psalm & Gospel" {
//                    psalmAndGospels.append(PsalmAndGospel(subSection: subSection,
//                                                          sectionTitle: section.title ?? ""))
//                    return
//                }
//                if psalmAndGospels.count > 0 {
//                    psalmAndGospels.forEach({
//                        let passages = $0.subSection.readings.flatMap { $0.passages ?? [] }
//                        presentableSections.append(PresentableSection(passages: passages,
//                                                                      subSectionTitle: $0.subSection.title?.psalmAndGospelFormat ?? "",
//                                                                      title: $0.sectionTitle))
//                    })
//                    psalmAndGospels = []
//                }
//                 subSection.readings.forEach({
//                     let passages = $0.passages
//                     presentableSections.append(PresentableSection(passages: passages ?? [],
//                                                                   subSectionTitle: subSection.title ?? "",
//                                                                   title: section.title ?? ""))
//                 })
//            }
//        })
//        if psalmAndGospels.count > 0 {
//            psalmAndGospels.forEach({
//                let passages = $0.subSection.readings.flatMap { $0.passages ?? [] }
//                presentableSections.append(PresentableSection(passages: passages,
//                                                              subSectionTitle: $0.subSection.title?.psalmAndGospelFormat ?? "",
//                                                              title: $0.sectionTitle))
//            })
//            psalmAndGospels = []
//        }
//    }
//    
//    func hasOneName(for section: PresentableSection) -> Bool {
//        section.passages.dropFirst().allSatisfy({ $0.bookTranslation == section.passages.first?.bookTranslation })
//    }
//}



