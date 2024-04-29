//
//  SaintImageView.swift
//  Agios
//
//  Created by Victor on 4/25/24.
//

import SwiftUI

struct SaintImageView: View {
    
    @EnvironmentObject private var occasionalViewModel: OccasionsViewModel
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
                    
    
            } else if viewModel.isLoading {
                ProgressView()
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
        SaintImageView(icon: dev.icon)
            .environmentObject(OccasionsViewModel())
            .environmentObject(IconImageViewModel(icon: dev.icon))
    }
}
