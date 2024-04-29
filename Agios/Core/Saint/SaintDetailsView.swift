//
//  SaintDetailsView.swift
//  Agios
//
//  Created by Victor on 4/25/24.
//

import SwiftUI

struct SaintDetailsView: View {
    
    let icon: IconModel
    let iconographer: Iconagrapher
    @Binding var showImageViewer: Bool
    @Binding var selectedSaint: IconModel?
    @EnvironmentObject private var occasionalViewModel: OccasionsViewModel
    
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
//                    Button {
//                        occasionalViewModel.openSaint = false
//                        selectedSaint = nil
//                        HapticsManager.instance.impact(style: .light)
//                    } label: {
//                        NavigationButton(labelName: .down, backgroundColor: .primary300)
//                            .padding(.horizontal, 20)
//                    }
//                    .buttonStyle(BouncyButton())
                    
                    VStack(alignment: .leading, spacing: 32) {
                        SaintImageView(icon: icon)
                            .scaledToFill()
                            .frame(width: 353, height: 337)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    showImageViewer = true
                                    selectedSaint = icon
                                }
                            }
                    

                        VStack(alignment: .leading, spacing: 12) {
                            Text(icon.caption ?? "")
                                .font(.title2)
                            .fontWeight(.semibold)
                            
                            
                            Text("Iconographer - \(iconographer.name ?? "Non")")
                                .font(.callout)
                                .fontWeight(.medium)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                                .background(.primary300)
                                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    divider
                    description
                    divider
                    commemoration
                    divider
                    highlights
                }
                .kerning(-0.4)
                .padding(.vertical, 24)
                .fontDesign(.rounded)
                
            }
            
            
        }
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.primary100)
                .ignoresSafeArea()
              //  .matchedGeometryEffect(id: "saintBackground", in: namespace)
        )
        .mask {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .ignoresSafeArea()
              //  .matchedGeometryEffect(id: "saintView", in: namespace)
        }
        .overlay {
            if showImageViewer {
                ImageViewer(icon: selectedSaint ?? dev.icon, showImageViewer: $showImageViewer, selectedSaint: $selectedSaint)
            }
            
        }
        

    }
}


struct SaintDetailsView_Preview: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        SaintDetailsView(icon: dev.icon, iconographer: dev.iconagrapher, showImageViewer: .constant(false), selectedSaint: .constant(dev.icon))
            .environmentObject(OccasionsViewModel())
            .environmentObject(IconImageViewModel(icon: dev.icon))
    }
}


extension SaintDetailsView {
    private var description: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "book.pages")
                    .foregroundStyle(.gray400)
                
                Text("Description")
                    .fontWeight(.semibold)
            }
            .font(.title3)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Lorem ipsum dolor sit amet consectetur. Quam malesuada ut magna consectetur. Elementum scelerisque mauris sed maecenas nisi faucibus vitae. Sed mattis sit amet quam. Id mauris.")
                    .foregroundStyle(.gray400)
                    .fontWeight(.medium)
                
                HStack(alignment: .center, spacing: 4) {
                    Text("Read more")
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                
            }
        }
        .padding(.horizontal, 20)

    }
    
    private var commemoration: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "star")
                    .foregroundStyle(.gray400)
                
                Text("Commemoration")
                    .fontWeight(.semibold)
            }
            .font(.title3)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Lorem ipsum dolor sit amet consectetur. Quam malesuada ut magna consectetur. Elementum scelerisque mauris sed maecenas nisi faucibus vitae. Sed mattis sit amet quam. Id mauris.")
                    .foregroundStyle(.gray400)
                    .fontWeight(.medium)
                
                HStack(alignment: .center, spacing: 4) {
                    Text("Read more")
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                
            }
        }
        .padding(.horizontal, 20)

    }
    
    private var highlights: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "rays")
                    .foregroundStyle(.gray400)
                
                Text("Highlights")
                    .fontWeight(.semibold)
            }
            .font(.title3)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Lorem ipsum dolor sit amet consectetur. Quam malesuada ut magna consectetur. Elementum scelerisque mauris sed maecenas nisi faucibus vitae. Sed mattis sit amet quam. Id mauris.")
                    .foregroundStyle(.gray400)
                    .fontWeight(.medium)
                
                HStack(alignment: .center, spacing: 4) {
                    Text("Read more")
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                
            }
        }
        .padding(.horizontal, 20)

    }
    
    private var divider: some View {
        Divider()
            .background(.gray50)
    }
}



