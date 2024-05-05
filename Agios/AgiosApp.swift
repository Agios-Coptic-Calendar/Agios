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
    @StateObject private var imageViewModel = IconImageViewModel(icon: IconModel(id: "", created: "", updated: "", caption: "", image: "", croppedImage: "", iconagrapher: Iconagrapher(created: "", id: "", name: "", updated: "")))
    
    @Namespace var namespace
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView(iconographer: dev.iconagrapher, namespace: namespace)
                    .environmentObject(occasionViewModel)
                    .environmentObject(imageViewModel)       
            }
            
        }
    }
}
