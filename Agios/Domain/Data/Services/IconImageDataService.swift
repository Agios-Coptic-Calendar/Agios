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
    private let fileManager = LocalFileManager.instance
    private let folderName = "saint_images"
    private let imageName: String
    private let icon: IconModel
    
    init(urlString: String, icon: IconModel) {
        self.icon = icon
        self.imageName = icon.id
        Task {
          await getIconFromFileManager(urlString: urlString)
        }
        
    }
    
    private func getIconFromFileManager(urlString: String) async {
           if let savedImage = fileManager.getImage(imageName: icon.id, folderName: folderName) {
               image = savedImage
               print("Retrieved Image from File Manager")
           } else {
               await downloadIconImage(urlString: urlString)
               print("Downloading Image Now")
           }
       }
    
    private func downloadIconImage(urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloadedImage = UIImage(data: data) {
                image = downloadedImage
                fileManager.saveImage(image: downloadedImage, imageName: imageName, folderName: folderName)
            }
        } catch {
            print(error)
        }
    }
    
}

    
