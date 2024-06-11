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
            VStack(alignment: .leading, spacing: 16) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    NavigationButton(labelName: .down, backgroundColor: .gray100, foregroundColor: .gray900)
                })
                .padding(.horizontal, 18)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(formatTitleText(story.saint ?? "Title"))
                            .font(.largeTitle)
                            .foregroundStyle(.gray900)
                            .fontWeight(.semibold)
                        
                        Text(formatStoryText(story.story ?? "story"))
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray700)  
                    }
                    .padding(.horizontal, 18)
                    .textSelection(.enabled)
                    .fontDesign(.rounded)
                }
            }
            .padding(.top, 24)
        }
        .kerning(-0.4)
    }
    private func formatStoryText(_ storyText: String) -> String {
        return storyText.replacingOccurrences(of: "\n", with: "\n\n")
    }
    private func formatTitleText(_ storyText: String) -> String {
        return storyText.replacingOccurrences(of: "\n", with: "")
    }
}

#Preview {
    StoryDetailView(story: dev.story)
}
