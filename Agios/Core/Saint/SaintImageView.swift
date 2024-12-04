//
//  SaintImageView.swift
//  Agios
//
//  Created by Victor on 4/25/24.
//

import SwiftUI
import Shimmer

enum ImageType {
    case cropped
    case full
}

struct SaintImageView: View {
    
    @StateObject var viewModel: IconImageViewModel
    let imageType: ImageType  // Add a parameter to specify the image type
    
    init(icon: IconModel, imageType: ImageType = .cropped) {
        _viewModel = StateObject(wrappedValue: IconImageViewModel(icon: icon))
        self.imageType = imageType
    }
    
    var body: some View {
        ZStack {
            switch imageType {
            case .cropped:
                if let croppedImage = viewModel.croppedImage {
                    Image(uiImage: croppedImage)
                        .resizable()
                        .scaledToFit()
                } else if viewModel.isLoading {
                    loadingShimmer
                } else {
                    fallbackShimmer
                }
            case .full:
                if let fullImage = viewModel.fullImage {
                    Image(uiImage: fullImage)
                        .resizable()
                        .scaledToFit()
                } else if viewModel.isLoading {
                    loadingShimmer
                } else {
                    fallbackShimmer
                }
            }
        }
    }
    
    // Extract shimmer into reusable views
    private var loadingShimmer: some View {
        ZStack {
            ShimmerView(heightSize: 350, cornerRadius: 24)
                .frame(width: 300, alignment: .leading)
                .transition(.opacity)
                .padding(.vertical, 25)
        }
        .clipShape(Rectangle())
    }
    
    private var fallbackShimmer: some View {
        ZStack {
            ShimmerView(heightSize: 350, cornerRadius: 24)
                .frame(width: 300, alignment: .leading)
                .transition(.opacity)
                .padding(.vertical, 25)
        }
        .clipShape(Rectangle())
    }
}

struct SaintImageView_Preview: PreviewProvider {
    static var previews: some View {
        SaintImageView(icon: dev.icon, imageType: .cropped)
            .environmentObject(IconImageViewModel(icon: dev.icon))
    }
}


