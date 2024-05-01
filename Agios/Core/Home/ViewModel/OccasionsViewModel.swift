//
//  OccasionsViewModel.swift
//  Agios
//
//  Created by Victor on 19/04/2024.
//

import Foundation
import Combine
import SwiftUI

class OccasionsViewModel: ObservableObject {
    @Published var icons: [IconModel] = []
    @Published var stories: [Story] = []
    @Published var readings: [DataReading] = []
    @Published var dataClass: DataClass? = nil
    @Published var subSection: [SubSection] = []
    @Published var passages: [Passage] = []
    
    @Published var isShowingFeastName = true
    //private let dataService: OccasionDataService
    @Published var isLoading: Bool = false
    @Published var copticDateTapped: Bool = false
    @Published var defaultDateTapped: Bool = false
    @Published var openSheet: Bool = false
    @Published var selectedDate: Date = Date()
    @State private var showHeroView: Bool = true
    
    @Published var showImageViewer: Bool = false
    @Published var selectedSaint: IconModel? = nil
    @Published var imageViewerOffset: CGSize = .zero
    @Published var backgroundOpacity: Double = 1
    @Published var imageScaling: Double = 1
    
    
    var feastName: String?
    var liturgicalInformation: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getPosts()
        self.isLoading = true
//        self.dataService = OccasionDataService()
//        self.addSubscribers()
    }
    
//    func addSubscribers() {
//        dataService.$icons
//            .sink { [weak self] _ in
//                self?.isLoading = false
//            } receiveValue: {[weak self] (returnedIcons) in
//                self?.icons = returnedIcons
//            }
//            .store(in: &cancellables)
//
//    }
    
    func getPosts() {
        guard let url = URL(string: "https://api.agios.co/occasions/get/27cg54wfacn5836") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: Response.self, decoder: JSONDecoder())
            .sink {[weak self] completion in
                withAnimation(.spring(response: 0.1, dampingFraction: 0.9, blendDuration: 1)) {
                    self?.isLoading = false
                }
                
                switch completion {
                case .finished:
                    print("finished!")
                case .failure(let error):
                    print("there was an error . \(error)")
                }
            } receiveValue: { [weak self] returnedResponse in
                self?.icons = returnedResponse.data.icons
                self?.stories = returnedResponse.data.stories ?? []
                self?.readings = returnedResponse.data.readings ?? []
                self?.dataClass = returnedResponse.data
                self?.retrievePassages()
                print("returned passage details")
            }
            .store(in: &cancellables)
    }
    
    func retrievePassages() {
        passages = readings.compactMap { $0.subSections }.flatMap{ $0 }.compactMap { $0.readings }.flatMap { $0 }.compactMap { $0.passages }.flatMap { $0 }
    }
    
    

    func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }


    func formattedDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date)
        formatter.dateStyle = .long
        return "\(day) " + "\(month)"
    }

    var copticDate: String {
       Date.copticDate()
    }
    
    var fastView: String {
        isShowingFeastName ? feastName ?? "" : liturgicalInformation ?? ""
        
    }
    
    func onChange(value: CGSize) {
        
        // updating offset
        imageViewerOffset = value
        
        //calculating blur intensity
        let halgHeight = UIScreen.main.bounds.height / 2
        let progress = imageViewerOffset.height / halgHeight
        
        withAnimation(.default) {
            backgroundOpacity = Double(1 - (progress < 0 ? -progress : progress))
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 1)) {
            var translation = value.translation.height
            
            if translation <  0 {
                translation = -translation
            }
            
            if translation < 250 {
                imageViewerOffset = .zero
                backgroundOpacity = 1
            } else {
                selectedSaint = nil
                showImageViewer = false
                imageViewerOffset = .zero
                backgroundOpacity = 1
            }
        }
    }

}



