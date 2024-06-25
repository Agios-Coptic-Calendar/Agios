//
//  GroupedSaintImageView.swift
//  Agios
//
//  Created by Victor on 6/9/24.
//

import SwiftUI

struct GroupedSaintImageView: View {
    @EnvironmentObject private var vm: OccasionsViewModel
    @Binding var selectedSaint: IconModel?
    @Binding var showStory: Bool?
    @State private var showGDView: Bool = false
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            ForEach(Array(vm.filteredIcons.enumerated()), id: \.element.id) { index, saint in
                let reversedIndex = vm.filteredIcons.count - index - 1
                HomeSaintImageView(namespace: namespace, icon: saint)
                    .transition(.scale(scale: 1))
                    .offset(y: CGFloat(reversedIndex) * -70)
                    .scaleEffect(0.98 - (CGFloat(reversedIndex) * 0.15), anchor: .bottom)
                    .contextMenu(ContextMenu(menuItems: {
                        Button {
                            selectedSaint = saint
                            showStory?.toggle()
                        } label: {
                            if vm.getStory(forIcon: saint) != nil {
                                Label("See story", systemImage: "book")
                            } else {
                                Text("No story")
                            }
                            
                        }
                        .disabled((vm.getStory(forIcon: saint) != nil) == true ? false : true)

                    }))
                    .onTapGesture {
                        gdSegue(icon: selectedSaint ?? dev.icon)
                        vm.viewState = .expanded
                        selectedSaint = saint
                        
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                            vm.viewState = .imageView
                            vm.selectedSaint = saint
                        }
                        
                    }
                    .opacity(vm.selectedSaint == saint ? 0 : 1)
                    
            }
//            .navigationDestination(isPresented: $showGDView, destination: {
//                GroupedDetailLoadingView(icon: selectedSaint, story: vm.getStory(forIcon: vm.filteredIcons.first ?? dev.icon) ?? dev.story, selectedSaint: $selectedSaint)
//                    .navigationBarBackButtonHidden(true)
//                    .environmentObject(dev.occasionsViewModel)
//            })
        }
//        .background(
//            RoundedRectangle(cornerRadius: 16, style: .continuous)
//                .fill(.clear)
//                .matchedGeometryEffect(id: "background", in: namespace)
//        )
//        .mask({
//            RoundedRectangle(cornerRadius: 16, style: .continuous)
//                .matchedGeometryEffect(id: "mask", in: namespace)
//        })
    }
    private func gdSegue(icon: IconModel) {
        selectedSaint = icon
        showGDView.toggle()
    }
}

struct GroupedSaintImageView_Previews: PreviewProvider {
    @State static var selectedSaint: IconModel? = nil
    @State static var showStory: Bool? = false
    @Namespace static var namespace
    
    static var previews: some View {
        GroupedSaintImageView(selectedSaint: $selectedSaint, showStory: $showStory, namespace: namespace)
            .environmentObject(OccasionsViewModel())
    }
}


