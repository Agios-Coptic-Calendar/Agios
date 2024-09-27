//
//  AgiosApp.swift
//  Agios
//
//  Created by Daniel Kamel on 17/04/2024.
//

import SwiftUI
import Shake

@main
struct AgiosApp: App {
    
    @StateObject private var occasionViewModel = OccasionsViewModel()
    @StateObject private var iconImageViewModel = IconImageViewModel(icon: dev.icon)
    @StateObject private var imageViewModel = IconImageViewModel(icon: IconModel(id: "", created: "", updated: "", caption: "", explanation: "", story: [], image: "", croppedImage: "", iconagrapher: .iconagrapher(Iconagrapher(id: "", name: "", url: ""))))
    
    @Namespace var namespace
    @Namespace var transition
    @State private var showLaunchView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            ZStack(content: {
                NavigationStack {
                    HeroWrapper {
                        //SynaxarsDetailsView()
                        //HeroTransitionView(namespace: namespace)
                        HomeView(iconographer: dev.iconagrapher, namespace: namespace, transition: transition)
                            .environmentObject(occasionViewModel)
                            .environmentObject(imageViewModel)
                            .environmentObject(iconImageViewModel)
                    }
                    
                }
                
                ZStack(content: {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.opacity.animation(.easeOut(duration: 0.2)))
                            .environmentObject(occasionViewModel)
                    }
                })
                .zIndex(2.0)
            })
            .onAppear {
                Shake.start(apiKey: "s37m9XuXly1HV11xU5sVa9QJQ8WvrpEtU50GJ9NsLEst4e84m9yAwuZ")
            }
        }
    }
}
