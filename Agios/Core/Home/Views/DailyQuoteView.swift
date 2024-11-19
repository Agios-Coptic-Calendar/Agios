//
//  DailyQuoteView.swift
//  Agios
//
//  Created by Victor on 5/2/24.
//

import SwiftUI

struct DailyQuoteView: View {
    @ObservedObject var viewModel: DailyQuoteViewModel
    let isLoading: Bool
    @State private var currentIndex: Int = 0
    
    var body: some View {
        ZStack {
            if isLoading {
                ShimmerView(heightSize: 250, cornerRadius: 24)
                    .padding(.horizontal, 20)
            } else {
                VStack(alignment: .center, spacing: 16) {
                    Text("Daily Quote".uppercased())
                        .foregroundStyle(.gray900)
                        .fontWeight(.semibold)
                        .font(.callout)
                        .kerning(1.3)
                    
                    ZStack {
                        ForEach(viewModel.currentQuotes.indices, id: \.self) { index in
                            if index == currentIndex {
                                let quote = viewModel.currentQuotes[index]
                                VStack(alignment: .center, spacing: 16) {
                                    ZStack {
                                        Text("❝ ").foregroundStyle(.primary900).font(.title2).fontWeight(.black).fontDesign(.monospaced) +
                                        Text("\(quote.body)") +
                                        Text(" ❞").foregroundStyle(.primary900).font(.title2).fontWeight(.black).fontDesign(.monospaced)
                                    }
                                    .multilineTextAlignment(.center)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                    .textSelection(.enabled)
                                    .kerning(-0.4)

                                    Text(quote.author.uppercased())
                                        .foregroundStyle(.gray900)
                                        .fontWeight(.semibold)
                                        .font(.callout)
                                        .kerning(1.3)
                                }
                                .transition(.blurReplace().combined(with: .scale(0.85)))
                            }
                        }
                    }
                    .gesture(
                        TapGesture(count: 2)
                            .onEnded {
                                if viewModel.currentQuotes.count > 1 {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                        currentIndex = (currentIndex + 1) % viewModel.currentQuotes.count
                                        HapticsManager.instance.impact(style: .soft)
                                    }
                                }
                            }
                    )
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(.primary200)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(.primary900, style: StrokeStyle(lineWidth: 1, dash: [10, 5], dashPhase: 3), antialiased: false)
                }
                .padding(.horizontal, 20)
            }
        }

    }
}

#Preview {
    DailyQuoteView(viewModel: DailyQuoteViewModel(), isLoading: false)
}
