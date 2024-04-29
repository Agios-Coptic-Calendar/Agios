//
//  SaintImageView.swift
//  Agios
//
//  Created by Victor on 22/04/2024.
//

import SwiftUI
import Combine

struct HomeSaintImageView: View {
    
    @StateObject var viewModel: IconImageViewModel
    let icon: IconModel
    
    init(icon: IconModel) {
        _viewModel = StateObject(wrappedValue: IconImageViewModel(icon: icon))
        self.icon = icon
    }
    
    var body: some View {
        
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 350)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(alignment: .bottom) {
                        Text(icon.caption ?? "")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(8)
                            .padding(.horizontal, 3)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color.gray900.opacity(0.8))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                    .background(Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 300, maxHeight: 350)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .blur(radius: 10)
                        .offset(x:8, y: 11)
                        .opacity(0.65)
                        .overlay(Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 300, maxHeight: 350)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous)))
                    )
                    .frame(height: 430)
    
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: 300, maxHeight: 350)
                    .background(.primary300)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
            } else {
                Image(systemName: "questionmark")
            }
        }
        .fontDesign(.rounded)
        .fontWeight(.semibold)
    }

}

struct SaintImageView_Preview: PreviewProvider {
    static var previews: some View {
        HomeSaintImageView(icon: dev.icon)
    }
}


