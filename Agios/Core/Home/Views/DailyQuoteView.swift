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
    
    var body: some View {
        ZStack {
           if isLoading {
                ShimmerView(heightSize: 250, cornerRadius: 24)
                   .padding(.horizontal, 20)
           } else {
               ZStack {
                   VStack(alignment: .center, spacing: 16) {
                       Text("Daily Quote".uppercased())
                           .foregroundStyle(.gray900)
                           .fontWeight(.semibold)
                           .font(.callout)
                           .kerning(1.3)
                       
                       ZStack {
                           Text("❝ ").foregroundStyle(.primary900).font(.title2).fontWeight(.black).fontDesign(.monospaced) +
                           Text("\(viewModel.currentQuote?.body ?? "Fact is empty.")") +
                           Text(" ❞").foregroundStyle(.primary900).font(.title2).fontWeight(.black).fontDesign(.monospaced)
                       }
                       .multilineTextAlignment(.center)
                       .font(.title3)
                       .fontWeight(.semibold)
                       .foregroundStyle(.black)
                       .textSelection(.enabled)
                       .kerning(-0.4)

                       
                       Text(viewModel.currentQuote?.author.uppercased() ?? "")
                           .foregroundStyle(.gray900)
                           .fontWeight(.semibold)
                           .font(.callout)
                           .kerning(1.3)
                   }
                   .padding(.vertical, 24)
                   .padding(.horizontal, 16)
                   .frame(maxWidth: .infinity, alignment: .center)
                   .background(.primary200)
                   .clipShape(RoundedRectangle(cornerRadius: 24, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                   .overlay(content: {
                       RoundedRectangle(cornerRadius: 24, style: .continuous)
                           .stroke(.primary900, style: StrokeStyle(lineWidth: 1, dash: [10,5], dashPhase: 3), antialiased: false)
                   })
               .padding(.horizontal, 20)
               }
           }
        }
    }
}

#Preview {
    DailyQuoteView(viewModel: DailyQuoteViewModel(), isLoading: false)
}
