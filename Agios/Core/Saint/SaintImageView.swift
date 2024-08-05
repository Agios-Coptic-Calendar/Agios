//
//  SaintImageView.swift
//  Agios
//
//  Created by Victor on 4/25/24.
//

import SwiftUI
import Shimmer

struct SaintImageView: View {
    
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
                    
    
            } else if viewModel.isLoading {
                ZStack {
                    ShimmerView(heightSize: 350, cornerRadius: 24)
                        .frame(width: 300, alignment: .leading)
                        .transition(.opacity)
                        .padding(.vertical, 25)
                }
                .clipShape(Rectangle())
                    
            } else {
                ZStack {
                    ShimmerView(heightSize: 350, cornerRadius: 24)
                        .frame(width: 300, alignment: .leading)
                        .transition(.opacity)
                        .padding(.vertical, 25)
                }
                .clipShape(Rectangle())
                
            }
        }
    }

}

struct SaintImageView_Preview: PreviewProvider {
    static var previews: some View {
        SaintImageView(icon: dev.icon)
            .environmentObject(IconImageViewModel(icon: dev.icon))
    }
}
