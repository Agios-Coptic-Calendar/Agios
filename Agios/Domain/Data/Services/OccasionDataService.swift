//
//  OccasionDataService.swift
//  Agios
//
//  Created by Victor on 23/04/2024.
//

import Foundation
import SwiftUI
import Combine

class OccasionDataService {
    @Published var icons: [IconModel] = []
    private var iconsSubscription: AnyCancellable?
    
    init() { 
        downloadIconImage()
    }
    
    private func downloadIconImage() {
        guard let url = URL(string: "https://api.agios.co/occasions/get/gr3wna6vjuucyj8") else { return }
        iconsSubscription = NetworkingManager.download(url: url)
            .decode(type: Response.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleSinkCompletion, receiveValue: { [weak self] returnedResponse in
                self?.icons = returnedResponse.data.icons ?? []
                self?.iconsSubscription?.cancel()
            })
    }
    
    private func handleTryMapOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
}
