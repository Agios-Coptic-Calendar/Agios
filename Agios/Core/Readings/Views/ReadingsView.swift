//
//  ReadingsView.swift
//  Agios
//
//  Created by Victor on 18/04/2024.
//

import SwiftUI

struct ReadingsView: View {
    
    let passage: Passage
    let verse: Verse
    
    @EnvironmentObject var occasionViewModel: OccasionsViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()
            
            Rectangle()
                .fill(LinearGradient(colors: [.primary300, .clear], startPoint: .top, endPoint: .bottom))
                .frame(height: 48)
                .frame(maxWidth: .infinity) 
                .ignoresSafeArea()
                
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
//                    NavigationButton(labelName: .down)
//                        .onTapGesture {
//                            occasionViewModel.openSheet = false
//                        }
                    
                    VStack(alignment: .leading, spacing: 32) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("\(passage.bookTranslation ?? "")  \(passage.ref ?? "")")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                            
                            HStack(alignment: .center, spacing: 8, content: {
                                Text(passage.bookTranslation ?? "")

                                Circle()
                                    .frame(width: 4, height: 4, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                                Text("Liturgy")
                            })
                            .font(.body)
                            .fontWeight(.medium)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                            .background(.primary300)
                            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                        }
                        
                        ForEach(passage.verses ?? []) { verse in
                            
                            
                            HStack(alignment: .firstTextBaseline) {
                                Text("\(verse.chapter ?? 0)")
                                    .font(.callout)
                                Text(verse.text ?? "")
                                    .fontWeight(.medium)
                                .font(.title2)
                            }
                        }
                       
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 64)
            }
            .scrollIndicators(.hidden)
        }
        .kerning(-0.4)
        .foregroundStyle(.gray900)
        .fontDesign(.rounded)
    }
}

#Preview {
    ReadingsView(passage: dev.passages, verse: dev.verses)
        .environmentObject(OccasionsViewModel())
}
