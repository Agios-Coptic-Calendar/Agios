//
//  SaintGroupImageView.swift
//  Agios
//
//  Created by Victor on 6/9/24.
//


import SwiftUI

struct SaintGroupImageView: View {
    
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
                ProgressView()
                    .background(.primary300)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    
                    
            } else {
                Image("placeholder")
                    .resizable()
                    .scaledToFill()
                
            }
        }
    }

}

struct SaintGroupImageView_Preview: PreviewProvider {
    static var previews: some View {
        SaintImageView(icon: dev.icon)
            .environmentObject(IconImageViewModel(icon: dev.icon))
    }
}

