////
////  SaintHomeView.swift
////  Agios
////
////  Created by Victor on 4/26/24.
////
//
//import SwiftUI
//
//struct SaintHomeView: View {
//    
//    let icon: IconModel
//    let iconographer: Iconagrapher
//    var namespace: Namespace.ID
//    @EnvironmentObject private var occasionViewModel: OccasionsViewModel
//    
//    var body: some View {
//        Button {
//            withAnimation {
//                occasionViewModel.openSaint = true
//            }
//            HapticsManager.instance.impact(style: .soft)
//        } label: {
//            HomeSaintImageView(icon: icon)
//        }
//        .buttonStyle(GrowingButton())
//        .scrollTransition { content, phase in
//            content
//                .rotation3DEffect(Angle(degrees: phase.isIdentity ? 0 : -10), axis: (x: 0, y: 50, z: 0))
//                .blur(radius: phase.isIdentity ? 0 : 2)
//                .scaleEffect(phase.isIdentity ? 1 : 0.95)
//        }
//
//        ScrollView(.horizontal, showsIndicators: false) {
//             HStack(spacing: 24) {
//                 ForEach(occasionViewModel.icons) { icon in
//
//                 }
//                 
//                 
//             }
//             .padding(.top, -24)
//             .padding(.horizontal, 24)
//         }
//    }
//}
//
//struct SaintHomeView_Preview: PreviewProvider {
//    
//    @Namespace static var namespace
//    
//    static var previews: some View {
//        SaintHomeView(icon: dev.icon, iconographer: dev.iconagrapher, namespace: namespace)
//            .environmentObject(OccasionsViewModel())
//    }
//}
