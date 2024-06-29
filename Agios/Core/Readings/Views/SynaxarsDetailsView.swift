//
//  SynaxarsDetailsView.swift
//  Agios
//
//  Created by Victor on 18/04/2024.
//

import SwiftUI


struct SynaxarsDetailsView: View {
    let icon: IconModel
    @Namespace var namespace
    @State var viewState: ViewState = .collapsed
    
    var body: some View {
        ZStack {
            switch viewState {
            case .collapsed:
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Abba Agathon")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .padding(.horizontal, 3)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray900.opacity(0.8))
                }
                .foregroundStyle(.white)
                .background(
                    
                    SaintImageView(icon: icon)
                        .matchedGeometryEffect(id: "back", in: namespace)
                        .scaledToFill()
                )
                .mask({
                    RoundedRectangle(cornerRadius: 24)
                        .matchedGeometryEffect(id: "mask", in: namespace)
                })
                .frame(width: 300, height: 350)
                .onTapGesture {
                    withAnimation {
                        viewState = .expanded
                    }
                }
                
            case .expanded:
                ScrollView {
                    VStack {}
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .padding(20)
                    .background(
                        SaintImageView(icon: icon)
                            .matchedGeometryEffect(id: "back", in: namespace)
                            .scaledToFill()
                            .onTapGesture {
                                withAnimation {
                                    viewState = .imageView
                                }
                            }
                    )
                    .mask({
                        RoundedRectangle(cornerRadius: 24)
                            .matchedGeometryEffect(id: "mask", in: namespace)
                    })
                }
                
            case .imageView:
                VStack {}
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .background(
                    SaintImageView(icon: icon)
                        .matchedGeometryEffect(id: "back", in: namespace)
                        .scaledToFit()
                        .zoomable()
                )
                .mask({
                    RoundedRectangle(cornerRadius: 0)
                        .matchedGeometryEffect(id: "mask", in: namespace)
                })

            }
        }
        .overlay {
            Button("Go to first") {
                withAnimation {
                    viewState = .expanded
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SynaxarsDetailsView(icon: dev.icon)
}




/*
 ZStack {
     if !show {
         VStack(alignment: .leading) {
             Spacer()
             Text("Abba Agathon")
                 .font(.body)
                 //.matchedGeometryEffect(id: "title", in: namespace)
                 .multilineTextAlignment(.center)
                 .padding(8)
                 .padding(.horizontal, 3)
                 .foregroundColor(.white)
                 .frame(maxWidth: .infinity)
                 .background(Color.gray900.opacity(0.8))
         }
         //.padding(20)
         .foregroundStyle(.white)
         .background(
             Image("Abba Agathon")
                 .resizable()
                 .matchedGeometryEffect(id: "back", in: namespace)
                 .scaledToFill()
                 
         )
         .mask({
             RoundedRectangle(cornerRadius: 24)
                 .matchedGeometryEffect(id: "mask", in: namespace)
         })
         .frame(width: 300, height: 350)
         
             
     } else {
         ScrollView {
             VStack(alignment: .trailing) {
                 Spacer()
                 Text("Example of match geo")
                     .matchedGeometryEffect(id: "sub", in: namespace)
                 Text("Zuriks")
                     .matchedGeometryEffect(id: "title", in: namespace)
                     .frame(maxWidth: .infinity, alignment: .trailing)
                     .font(.title)
                 
             }
             .onTapGesture {
                 withAnimation {
                     show.toggle()
                 }
             }
             .frame(height: 300)
             .padding(20)
             .foregroundStyle(.yellow)
             .background(
                 Image("Abba Agathon")
                     .resizable()
                     .matchedGeometryEffect(id: "back", in: namespace)
                     .scaledToFill()
                 
             )
             .mask({
                 RoundedRectangle(cornerRadius: 24)
                     .matchedGeometryEffect(id: "mask", in: namespace)
             })
         }
             
     }
 }
 .onTapGesture {
     withAnimation {
         show.toggle()
     }
 }

 */
