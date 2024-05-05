//
//  IconImageViewModel.swift
//  Agios
//
//  Created by Victor on 22/04/2024.
//

import Foundation
import SwiftUI
import Combine

class IconImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private var imageSubscription: AnyCancellable?
    private let icon: IconModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "icon_images"
    private var imageUrls: [String] = []
    private var currentIndex = 0
    private var cancellables = Set<AnyCancellable>()
    private let dataService: IconImageDataService
    
    
    init(icon: IconModel) {
        self.icon = icon
        self.isLoading = true
        self.dataService = IconImageDataService(urlString: icon.image, icon: icon)
        self.addSubscribers()
    }
    
    
    private func addSubscribers() {
        dataService.$image
            .sink {[weak self] _ in
                self?.isLoading = false
            } receiveValue: {[weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)

    }
}






