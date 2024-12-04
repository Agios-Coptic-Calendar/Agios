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
    @Published var croppedImage: UIImage? = nil
    @Published var fullImage: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var allowTapping: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let croppedImageService: IconImageDataService?
    private let fullImageService: IconImageDataService
    
    init(icon: IconModel) {
        // Initialize full image service
        self.fullImageService = IconImageDataService(urlString: icon.image, icon: icon)
        
        // Initialize cropped image service only if the URL is valid
        if let croppedImageUrl = icon.croppedImage, !croppedImageUrl.isEmpty {
            self.croppedImageService = IconImageDataService(urlString: croppedImageUrl, icon: icon)
        } else {
            self.croppedImageService = nil
        }
        
        self.addSubscribers()
    }
    
    func addSubscribers() {
        // Subscribe to the full image service
        fullImageService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                DispatchQueue.main.async {
                    self?.fullImage = returnedImage
                    print("Loaded full image")
                    self?.checkImageAvailability()
                }
            }
            .store(in: &cancellables)
        
        // Subscribe to the cropped image service if it exists
        croppedImageService?.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                DispatchQueue.main.async {
                    self?.croppedImage = returnedImage
                    print("Loaded cropped image")
                    self?.checkImageAvailability()
                }
            }
            .store(in: &cancellables)
    }
    
    private func checkImageAvailability() {
        // Decide which image to display
        if croppedImage != nil || fullImage != nil {
            isLoading = true
            allowTapping = true
        }
    }
}







