//
//  IconService.swift
//  AgiosWidgetExtension
//
//  Created by Nikola Veljanovski on 24.10.24.
//

import Foundation
import UIKit
import WidgetKit

struct WidgetService {
    enum WidgetServiceError: Error {
        case imageDataCorrupted
        case imageResizingFailed
        case imageDataConversionFailed
        case imageTooLarge
    }
    
    private static var cacheImagePath: URL {
        URL.cachesDirectory.appending(path: "saint.png")
    }
    
    private static var cacheDescriptionPath: URL {
        URL.cachesDirectory.appending(path: "agios_description")
    }
    
    static var cachedDescription: String? {
        guard let description = try? String(contentsOf: cacheDescriptionPath, encoding: .utf8) else {
            return nil
        }
        return description
    }
    
    static var cachedIcon: UIImage? {
        guard let imageData = try? Data(contentsOf: cacheImagePath) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    static var cachedIconAvailable: Bool {
        cachedIcon != nil
    }
    
    static var cachedDescriptionAvailable: Bool {
        cachedDescription != nil
    }
    
    static func fetchSaint() async throws -> Saint? {
        // Attempt to build the request URL
        guard let url = URL(string: "https://api.agios.co/occasions/get/date/\(WidgetService.date)") else {
            return nil
        }

        do {
            // Fetch the JSON data from the API
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode the JSON response into a Response object
            let response = try JSONDecoder().decode(Response.self, from: data)
            
            // Extract the first icon and its description (caption)
            let icon = response.data.icons?.first
            let description = icon?.caption ?? ""
            
            // Determine which image URL to use (croppedImage first, else image)
            var imageUrl: String?
            if let croppedImage = icon?.croppedImage,
               let image = icon?.image {
                if !croppedImage.isEmpty {
                    imageUrl = croppedImage + "?thumb=0x500"
                } else if !image.isEmpty {
                    imageUrl = image + "?thumb=0x500"
                }
            }

            // If we have an image URL, proceed to fetch and process the image
            if let imageUrl, !imageUrl.isEmpty {
                // Fetch the image data from the determined URL
                let (imageData, _) = try await URLSession.shared.data(from: URL(string: imageUrl)!)
                
                // Convert the fetched data into a UIImage
                guard let originalImage = UIImage(data: imageData) else {
                    throw WidgetServiceError.imageDataCorrupted
                }
                
                // Cache the compressed image and the description
                Task {
                    do {
                        try await WidgetService.cacheImage(imageData)
                        try await WidgetService.cacheDescription(description)
                    } catch {
                        throw WidgetServiceError.imageDataCorrupted
                    }
                }
                
                // Return the Saint object with the processed image and description
                return Saint(image: originalImage, description: description)
            }
            
            // If no valid image URL or no icon, return a placeholder
            return Saint(image: UIImage(named: "placeholder")!, description: "No data available")
        } catch {
            // If any step above fails, print error and return nil
            print("Error fetching icon: \(error)")
            return Saint(image: UIImage(named: "placeholder")!, description: "Tap to reload")
        }
    }

    // Helper function to resize an image to a given target size.
    // This will maintain aspect ratio as long as the targetSize is computed accordingly.
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        // Use UIGraphicsImageRenderer to draw the image into a new context of the given target size
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    private static func cacheImage(_ imageData: Data) async throws {
        try imageData.write(to: cacheImagePath)
    }
    
    private static func cacheDescription(_ description: String) async throws {
        try description.write(to: cacheDescriptionPath, atomically: true, encoding: .utf8)
    }
    
     static var date: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
}
