//
//  StoryDetailView.swift
//  Agios
//
//  Created by Victor on 6/6/24.
//

import SwiftUI

struct StoryDetailView: View {
    let story: Story
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 40) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    NavigationButton(labelName: .down, backgroundColor: .gray100, foregroundColor: .gray900)
                })
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(story.saint ?? "Title")
                            .font(.title)
                            .foregroundStyle(.gray900)
                            .fontWeight(.semibold)
                        
                        Text(story.story ?? "story")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray700)  
                    }
                    .padding(.horizontal, 20)
                    .textSelection(.enabled)
                    .fontDesign(.rounded)
                }
            }
            .padding(.top, 24)
        }
    }
}

#Preview {
    StoryDetailView(story: dev.story)
}
