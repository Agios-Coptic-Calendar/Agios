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
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        NavigationButton(labelName: .down, backgroundColor: .gray100, foregroundColor: .gray900)
                    })
                    
                    Divider()
                   
                    VStack(alignment: .leading, spacing: 24) {
                        Text(story.saint ?? "Title")
                            .font(.title)
                            .foregroundStyle(.gray900)
                            .fontWeight(.semibold)
                        
                        Text(story.story ?? "story")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.gray700)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)
                .textSelection(.enabled)
                .fontDesign(.rounded)
            }
        }
    }
}

#Preview {
    StoryDetailView(story: dev.story)
}
