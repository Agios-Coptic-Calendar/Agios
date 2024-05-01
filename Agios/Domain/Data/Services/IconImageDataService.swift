//
//  IconImageDataService.swift
//  Agios
//
//  Created by Victor on 22/04/2024.
//

import Foundation
import SwiftUI
import Combine

class IconImageDataService {
    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    
    init(urlString: String) {
        downloadIconImage(urlString: urlString)
    }
    
    private func downloadIconImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            }, receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
            })
    }
    
}

    
