//
//  AgiosApp.swift
//  Agios
//
//  Created by Daniel Kamel on 17/04/2024.
//

import SwiftUI

@main
struct AgiosApp: App {
    
    @StateObject private var occasionViewModel = OccasionsViewModel()
    @StateObject private var imageViewModel = IconImageViewModel(icon: IconModel(id: "", created: "", updated: "", caption: "", explanation: "", story: [], image: "", croppedImage: "", iconagrapher: .iconagrapher(Iconagrapher(id: "", name: "", url: ""))))
    
    @Namespace var namespace
    @Namespace var transition
    @State private var showLaunchView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack(content: {
                NavigationStack {
                    HomeView(iconographer: dev.iconagrapher, namespace: namespace, transition: transition)
                        .environmentObject(occasionViewModel)
                        .environmentObject(imageViewModel)
                }
                
                ZStack(content: {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.opacity.animation(.easeOut(duration: 0.2)))
                    }
                })
                .zIndex(2.0)
                
                
            })
            
            
        }
    }
}
