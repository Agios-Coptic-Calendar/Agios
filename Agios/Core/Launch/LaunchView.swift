//
//  LaunchView.swift
//  Agios
//
//  Created by Victor on 5/24/24.
//

import SwiftUI


struct LaunchView: View {
    
    @State private var logoText: [String] = "Agios".map {String($0)}
    @State private var showLogoText: Bool = false
    
    private let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View { 
        ZStack(content: {
            Rectangle()
                .fill(.linearGradient(colors: [
                    Color(red: 0.99, green: 0.98, blue: 0.96),
                    Color(red: 0.96, green: 0.93, blue: 0.88),
                    ],
                                      startPoint: .top,
                                      endPoint: .bottom))
                .ignoresSafeArea()
              
            ZStack(content: {
                if showLogoText {
                    HStack(spacing: 0) {
                        ForEach(logoText, id: \.self) { index in
                            Text(index)
                                .font(.largeTitle)
                                .kerning(-1)
                                .fontDesign(.rounded)
                                .fontWeight(.bold)
                                .foregroundStyle(.gray900)
                        }
                    }
                    .transition(AnyTransition.push(from: .leading).animation(.easeIn))
                }
            })
            .offset(x: showLogoText ? 17 : 0)
            .animation(.spring(response: 0.35, dampingFraction: 1, blendDuration: 1), value: showLogoText)

            
            Image("appIcon")
                .resizable()
                .frame(width: showLogoText ? 65 : 170, height: showLogoText ? 65 : 170, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(x: showLogoText ? -67 : 0) 
                //.scaleEffect(showLogoText ? 0.42 : 1)
                .animation(.spring(response: 0.35, dampingFraction: 1, blendDuration: 1), value: showLogoText)
            
        })
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                showLogoText.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                showLaunchView = false
            }
            
           
        }
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}


